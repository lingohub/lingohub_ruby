module Lingohub::Command
  class Resource < Base
    EXPECTED_STRATEGY_PARAMETERS = [
        'source:createNew',
        'source:updateExisting',
        'source:deactivateMissing',
        'target:createNew',
        'target:updateExisting',
        'target:deactivateMissing',
      ]

    def down
      project #project validation

      directory = File.join(Dir.pwd, extract_directory_from_args || "")
      raise(CommandFailed, "Error downloading resources. Path #{directory} does not exist") unless File.directory?(directory)

      if extract_query_from_args
        pull_search_results(directory)
      else
        download_resources(directory)
      end
    end

    def up
      project #project validation

      upload_resources(args)
    end

    private

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

    def extract_strategy_parameters
      result = {}

      EXPECTED_STRATEGY_PARAMETERS.each do |parameter|
        value = extract_option("--#{parameter}", nil)
        if value
          bool_value = to_bool(value, parameter)
          result.merge!({ parameter => value })
        end
      end
      result
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

    def download_resources(directory)
      files_source = extract_all_from_args ? project.resources.keys : args
      locale_as_filter = extract_locale_from_args

      files_source.each do |file_name|
        begin
          downloaded = project.download_resource(directory, file_name, locale_as_filter)
          display("#{file_name} downloaded") if downloaded
        rescue
          display "Error downloading #{file_name}. Response: #{$!.message || $!.response}"
        end
      end
    end

    def upload_resources(resources)
      path = extract_option('--path')
      resources.each do |file_name|
        begin
          file = File.expand_path(file_name, Dir.pwd)
          project.upload_resource(file, extract_locale_from_args, extract_strategy_parameters, path)
          display("#{file_name} uploaded")
        rescue
          display "Error uploading #{file_name}. Response: #{$!.message || $!.response}"
        end
      end
    end

    def to_bool(value, setting)
      return true if value == true || value =~ (/(true|t|yes|y|1)$/i)
      return false if value == false || value =~ (/(false|f|no|n|0)$/i)
      raise ArgumentError.new("boolean value expected for setting #{setting}, but was: \"#{value}\"")
    end
  end
end
