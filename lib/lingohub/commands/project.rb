require 'readline'
require 'launchy'

module Lingohub::Command
  class Project < Base
    def login
      Lingohub::Command.run_internal "auth:reauthorize", args.dup
    end

    def logout
      Lingohub::Command.run_internal "auth:delete_credentials", args.dup
      display "Local credentials cleared."
    end

    def list
      list = lingohub.projects.all
      if list.size > 0
        display "Projects:\n" + list.keys.map { |name|
          "- #{name}"
        }.join("\n")
      else
        display "You have no projects."
      end
    end

    def create
      title = args.shift.strip rescue nil
      lingohub.projects.create title
      display("Created #{title}")
    end

    def rename
      oldtitle = args[0].strip rescue raise(CommandFailed, "Invalid old project name")
      newtitle = args[1].strip rescue raise(CommandFailed, "Invalid new project name")

      project(oldtitle).update(:title => newtitle)
      display("Project renamed from #{oldtitle} to #{newtitle}")
    end

    def info
      display "=== #{project.title}"
      display "Web URL:        #{project.weburl}"
      display "Owner:          #{project.owner}"
      display "Opensource:     #{project.opensource}"
      display "Locales:        #{project.project_locales}"
      display "Description:    #{project.description}"
    end

    def open
      Launchy.open project.weburl
    end

    def destroy
      display "=== #{project.title}"
      display "Web URL:        #{project.weburl}"
      display "Owner:          #{project.owner}"

      if confirm_command(project.title)
        redisplay "Destroying #{project.title} ... "
        project.destroy
        display "done"
      end
    end

  end

end
