require 'lingohub/commands/resource'

module Lingohub::Command
  class Help < Base
    class HelpGroup < Array

      attr_reader :title

      def initialize(title)
        @title = title
      end

      def command(name, description)
        self << [name, description]
      end

      def space
        self << ['', '']
      end
    end

    def self.groups
      @groups ||= []
    end

    def self.group(title, &block)
      groups << begin
        group = HelpGroup.new(title)
        yield group
        group
      end
    end

    def self.create_default_groups!
      return if @defaults_created
      @defaults_created = true
      group 'General Commands' do |group|
        group.command 'help',                         'show this usage'
        group.command 'version',                      'show the gem version'
        group.space
        group.command 'login',                        "let's you (re)login"
        group.command 'logout',                       'logs you out by clearing your current credentials'
      end

      group 'Project Commands' do |group|
        group.command 'project:list',                         'list your projects'
        group.command 'project:open --project <name>',        'open the project in a web browser'
      end

      group 'Translation Commands' do |group|
        group.command 'resource:down --all --directory <path> --project <name>',                                          'download all resource files'
        group.command 'resource:down --locale <iso2_code> --all --directory <path> --project <name>',                     'download all resource files, using the given locale as filter'
        group.command 'resource:down <file1> <file2> ... --directory <path> --project <name>',                            'download specific resource files'

        strategy_desc = ""
        Lingohub::Command::Resource::EXPECTED_STRATEGY_PARAMETERS.each do |parameter|
          strategy_desc << " --#{parameter} true|false"
        end

        group.command "resource:up <file1> <file2> ... --locale <iso2_code> --project <name> --directory <path> [#{strategy_desc}]",          "upload specific resource files, a locale may be specified to tell lingohub the locale of file content"
      end
    end

    def index
      display usage
    end

    def version
      display Lingohub::Client.version
    end

    def usage
      self.class.groups.inject(StringIO.new) do |output, group|
        output.puts "=== %s" % group.title
        longest_command_length = 30

        group.each do |command, description|
          if command.empty?
            output.puts
          else
            if command.length > longest_command_length
              output.puts " %s\n    %s\n " % [command, description]
            else
              output.puts " %-*s # %s" % [longest_command_length, command, description]
            end
          end
        end
        output.puts
        output
      end.string
    end
  end
end

Lingohub::Command::Help.create_default_groups!
