require 'readline'
require 'launchy'

module Linguist::Command
  class App < Base
    def login
      Linguist::Command.run_internal "auth:reauthorize", args.dup
    end

    def logout
      Linguist::Command.run_internal "auth:delete_credentials", args.dup
      display "Local credentials cleared."
    end

    def list
      list = linguist.projects.all
      if list.size > 0
        display "Projects:\n" + list.keys.map { |name|
          "- #{name}"
        }.join("\n")
      else
        display "You have no projects."
      end
    end

    def create
      remote  = extract_option('--remote', 'linguist')
      stack   = extract_option('--stack', 'aspen-mri-1.8.6')
      timeout = extract_option('--timeout', 30).to_i
      addons  = (extract_option('--addons', '') || '').split(',')
      name = args.shift.downcase.strip rescue nil
      name = linguist.create_request(name, { :stack => stack })
      display("Creating #{name}...", false)
      begin
        Timeout::timeout(timeout) do
          loop do
            break if linguist.create_complete?(name)
            display(".", false)
            sleep 1
          end
        end
        display " done"

        addons.each do |addon|
          display "Adding #{addon} to #{name}... "
          linguist.install_addon(name, addon)
        end

        display app_urls(name)
      rescue Timeout::Error
        display "Timed Out! Check linguist info for status updates."
      end

      create_git_remote(name, remote || "linguist")
    end

    def rename
      name = extract_app
      newname = args.shift.downcase.strip rescue ''
      raise(CommandFailed, "Invalid name.") if newname == ''

      linguist.update(name, :name => newname)
      display app_urls(newname)

      if remotes = git_remotes(Dir.pwd)
        remotes.each do |remote_name, remote_app|
          next if remote_app != name
          if has_git?
            git "remote rm #{remote_name}"
            git "remote add #{remote_name} git@#{linguist.host}:#{newname}.git"
            display "Git remote #{remote_name} updated"
          end
        end
      else
        display "Don't forget to update your Git remotes on any local checkouts."
      end
    end

    def info
      title = (args.first && !args.first =~ /^\-\-/) ? args.first : extract_app
#      puts "list #{linguist.list[name]}"
#      project_url = linguist.list[name].link
#      response = linguist.get project_url

#      puts "YEAH HELI #{JSON.parse(res)}"
#      return

      project = linguist.projects[title]

      display "=== #{project.title}"
      display "Web URL:        #{project.weburl}"
      display "Owner:          #{project.owner}"
      display "Number of translation:      #{project.translations_count}"

      return

      collaborators = attrs[:collaborators].delete_if { |c| c[:email] == attrs[:owner] }
      unless collaborators.empty?
        first = true
        lead  = "Collaborators:"
        attrs[:collaborators].each do |collaborator|
          display "#{first ? lead : ' ' * lead.length}  #{collaborator[:email]}"
          first = false
        end
      end

    end

    def open
      project_title = extract_app
      url = linguist.projects[project_title].weburl
      puts "Opening #{url}"
      Launchy.open url
    end

    def rake
      app = extract_app
      cmd = args.join(' ')
      if cmd.length == 0
        display "Usage: linguist rake <command>"
      else
        linguist.start(app, "rake #{cmd}", :attached).each { |chunk| display(chunk, false) }
      end
    rescue Linguist::Client::AppCrashed => e
      error "Couldn't run rake\n#{e.message}"
    end

    def console
      app = extract_app
      cmd = args.join(' ').strip
      if cmd.empty?
        console_session(app)
      else
        display linguist.console(app, cmd)
      end
    rescue RestClient::RequestTimeout
      error "Timed out. Long running requests are not supported on the console.\nPlease consider creating a rake task instead."
    rescue Linguist::Client::AppCrashed => e
      error e.message
    end

    def console_session(app)
      linguist.console(app) do |console|
        console_history_read(app)

        display "Ruby console for #{app}.#{linguist.host}"
        while cmd = Readline.readline('>> ')
          unless cmd.nil? || cmd.strip.empty?
            console_history_add(app, cmd)
            break if cmd.downcase.strip == 'exit'
            display console.run(cmd)
          end
        end
      end
    end

    def restart
      app_name = extract_app
      linguist.restart(app_name)
      display "App processes restarted"
    end

    def dynos
      app = extract_app
      if dynos = args.shift
        current = linguist.set_dynos(app, dynos)
        display "#{app} now running #{quantify("dyno", current)}"
      else
        info = linguist.info(app)
        display "#{app} is running #{quantify("dyno", info[:dynos])}"
      end
    end

    def workers
      app = extract_app
      if workers = args.shift
        current = linguist.set_workers(app, workers)
        display "#{app} now running #{quantify("worker", current)}"
      else
        info = linguist.info(app)
        display "#{app} is running #{quantify("worker", info[:workers])}"
      end
    end

    def destroy
      app  = extract_app
      info = linguist.info(app)
      url  = info[:domain_name] || "http://#{info[:name]}.#{linguist.host}/"

      if confirm_command(app)
        redisplay "Destroying #{app} (including all add-ons)... "
        linguist.destroy(app)
        if remotes = git_remotes(Dir.pwd)
          remotes.each do |remote_name, remote_app|
            next if app != remote_app
            git "remote rm #{remote_name}"
          end
        end
        display "done"
      end
    end

    protected
    @@kb = 1024
    @@mb = 1024 * @@kb
    @@gb = 1024 * @@mb

    def format_bytes(amount)
      amount = amount.to_i
      return '(empty)' if amount == 0
      return amount if amount < @@kb
      return "#{(amount / @@kb).round}k" if amount < @@mb
      return "#{(amount / @@mb).round}M" if amount < @@gb
      return "#{(amount / @@gb).round}G"
    end

    def quantify(string, num)
      "%d %s" % [num, num.to_i == 1 ? string : "#{string}s"]
    end

    def console_history_dir
      FileUtils.mkdir_p(path = "#{home_directory}/.linguist/console_history")
      path
    end

    def console_history_file(app)
      "#{console_history_dir}/#{app}"
    end

    def console_history_read(app)
      history = File.read(console_history_file(app)).split("\n")
      if history.size > 50
        history = history[(history.size - 51), (history.size - 1)]
        File.open(console_history_file(app), "w") { |f| f.puts history.join("\n") }
      end
      history.each { |cmd| Readline::HISTORY.push(cmd) }
    rescue Errno::ENOENT
    rescue Exception => ex
      display "Error reading your console history: #{ex.message}"
      if confirm("Would you like to clear it? (y/N):")
        FileUtils.rm(console_history_file(app)) rescue nil
      end
    end

    def console_history_add(app, cmd)
      Readline::HISTORY.push(cmd)
      File.open(console_history_file(app), "a") { |f| f.puts cmd + "\n" }
    end

    def create_git_remote(app, remote)
      return unless has_git?
      return if git('remote').split("\n").include?(remote)
      return unless File.exists?(".git")
      git "remote add #{remote} git@#{linguist.host}:#{app}.git"
      display "Git remote #{remote} added"
    end
  end
end
