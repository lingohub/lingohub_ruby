require 'fileutils'

module Lingohub::Command
  class Base
    include Lingohub::Helpers

    attr_accessor :args
    attr_reader :autodetected_app

    def initialize(args, lingohub=nil)
      @args             = args
      @lingohub         = lingohub
      @autodetected_project_name = false
    end

    def lingohub
      @lingohub ||= Lingohub::Command.run_internal('auth:client', args)
    end

    def project_title(force=true)
      project_title = extract_project_title_from_args
      unless project_title
        project_title = extract_project_title_from_dir_name ||
          raise(CommandFailed, "No project specified.\nRun this command from project folder or set it adding --project <title>") if force
        @autodetected_project_name = true
      end
      project_title
    end

    def extract_project_title_from_args
      project_title = extract_option('--project', false)
      raise(CommandFailed, "You must specify a project title after --project") if project_title == false
      project_title
    end

    def extract_project_title_from_dir_name
      dir = Dir.pwd
      File.basename(dir)
    end

    def extract_app_from_git_config
      remote = git("config heroku.remote")
      remote == "" ? nil : remote
    end

    def extract_option(options, default=true)
      values = options.is_a?(Array) ? options : [options]
      return unless opt_index = args.select { |a| values.include? a }.first
      opt_position = args.index(opt_index) + 1
      if args.size > opt_position && opt_value = args[opt_position]
        if opt_value.include?('--')
          opt_value = nil
        else
          args.delete_at(opt_position)
        end
      end
      opt_value ||= default
      args.delete(opt_index)
      block_given? ? yield(opt_value) : opt_value
    end

    def git_url(name)
      "git@#{heroku.host}:#{name}.git"
    end

    def app_urls(name)
#      "#{web_url(name)} | #{git_url(name)}"
    end

    def escape(value)
      lingohub.escape(value)
    end

    def project(title=nil)
      title ||= project_title
      @project ||= lingohub.project(title)
    end
  end

  class BaseWithApp < Base
    attr_accessor :app

    def initialize(args, lingohub=nil)
      super(args, lingohub)
      @app ||= extract_app
    end
  end
end
