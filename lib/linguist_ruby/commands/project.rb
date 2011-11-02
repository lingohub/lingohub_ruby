require 'readline'
require 'launchy'

module Linguist::Command
  class Project < Base
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
      title = args.shift.downcase.strip rescue nil
      title ||= extract_from_dir_name
      linguist.projects.create title
      display("Created #{title}")
    end

    def rename
      oldtitle = args[0].downcase.strip rescue raise(CommandFailed, "Invalid old project name")
      newtitle = args[1].downcase.strip rescue raise(CommandFailed, "Invalid new project name")

      project(oldtitle).update(:title => newtitle)
      display("Project renamed from #{oldtitle} to #{newtitle}")
    end

    def info
      display "=== #{project.title}"
      display "Web URL:        #{project.weburl}"
      display "Owner:          #{project.owner}"
      display "Number of translation:      #{project.translations_count}"
    end

    def open
      Launchy.open project.weburl
    end

    def destroy
      display "=== #{project.title}"
      display "Web URL:        #{project.weburl}"
      display "Owner:          #{project.owner}"

      if confirm_command(project_title)
        redisplay "Destroying #{project_title} ... "
        project.destroy
        display "done"
      end
    end

  end

end
