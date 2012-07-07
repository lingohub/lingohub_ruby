module Lingohub::Command
  class Translation < Base
    def down
      project #project validation

      directory = File.join(Dir.pwd, extract_directory_from_args || "")
      raise(CommandFailed, "Error downloading translations. Path #{directory} does not exist") unless File.directory?(directory)

      if extract_query_from_args
        pull_search_results(directory)
      else
        pull_resources(directory)
      end
    end

    def up
      project #project validation

      push_resources(args)
    end

    private

    def rails_environment?
      true #TODO
    end

    def rails_locale_dir
      Dir.pwd + "/conf/locales"
    end

    def extract_directory_from_args
      return @directory if defined? @directory
      @directory = extract_option('--directory', false)
      raise(CommandFailed, "You must specify a directory after --directory") if @directory == false
      @directory
    end

    def extract_locale_from_args
      return @locale if defined? @locale
      @locale = extract_option('--locale', false)
      raise(CommandFailed, "You must specify a locale after --locale") if @locale == false
      @locale
    end

    def extract_all_from_args
      return @all if defined? @all
      @all = extract_option('--all', true)
      raise(CommandFailed, "You have not specify anything after --all") unless @all == true or @all.nil?
      @all
    end

    def extract_query_from_args
      return @query if defined? @query
      @query = extract_option('--query', false)
      raise(CommandFailed, "You have not specify anything after --query") if @query == false
      @query
    end

    def pull_search_results(directory)
      query = extract_query_from_args
      locale = extract_locale_from_args
      filename = args.first

      begin
        project.pull_search_results(directory, filename, query, locale)
        display("Search results for '#{query}' saved to #{filename}")
      rescue
        display "Error saving search results for '#{query}'. Response: #{$!.response || $!.message}"
      end
    end

    def pull_resources(directory)
      files_source = extract_all_from_args ? project.resources.keys : args
      locale_as_filter = extract_locale_from_args

      files_source.each do |file_name|
        begin
          downloaded = project.pull_resource(directory, file_name, locale_as_filter)
          display("#{file_name} downloaded") if downloaded
        rescue
          display "Error downloading #{file_name}. Response: #{$!.message || $!.response}"
        end
      end
    end

    def push_resources(resources)
      resources.each do |file_name|
        begin
          path = File.expand_path(file_name, Dir.pwd)
          project.push_resource(path, extract_locale_from_args)
          display("#{file_name} uploaded")
        rescue
          display "Error uploading #{file_name}. Response: #{$!.message || $!.response}"
        end
      end
    end
  end
end
