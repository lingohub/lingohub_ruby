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
        display "Projects:\n"
        list.each_pair { |name, project|
          display "- #{name}"
        }
      else
        display "You have no projects."
      end
    end

    def open
      Launchy.open project.weburl
    end

  end

end
