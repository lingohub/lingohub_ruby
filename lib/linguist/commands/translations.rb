module Linguist::Command
  class Translations < Base
    def down
      project #project validation

      directory = File.join(Dir.pwd, extract_directory_from_args || "")
      raise(CommandFailed, "Error downloading translations. Path #{directory} does not exist") unless File.directory?(directory)

      files_source = extract_all_from_args ? project.resources.keys : args
      files_source.each do |file_name|
        begin
          project.pull_resource(directory, file_name)
          display("#{file_name} downloaded")
        rescue
          display "Error downloading #{file_name}. Response: #{$!.message}"
        end
      end
    end

    def up
      project #project validation

      args.each do |file_name|
        begin
          path = File.expand_path(file_name, Dir.pwd)
          project.push_resource(path, extract_locale_from_args)
          display("#{file_name} uploaded")
        rescue
          display "Error uploading #{file_name}. Response: #{$!.response || $!.message}"
        end
      end
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
  end
end