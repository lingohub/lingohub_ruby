module Linguist::Command
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
#        group.command 'login',                        'log in with your linguist credentials'
#        group.command 'logout',                       'clear local authentication credentials'
#        group.space
        group.command 'list',                         'list your projects'
        group.command 'create <name>',                'create a new project'
        group.command 'info <name>',                  'show project info, like web url and number of translations'
        group.command 'open <name>',                  'open the app in a web browser'
        group.command 'rename <oldname> <newname>',   'rename the app'
        group.command 'destroy <name',                'destroy the app permanently'
        group.space
      end

#      group 'Plugins' do |group|
#        group.command 'plugins',                      'list installed plugins'
#        group.command 'plugins:install <url>',        'install the plugin from the specified git url'
#        group.command 'plugins:uninstall <url/name>', 'remove the specified plugin'
#      end
    end

    def index
      display usage
    end

    def version
      display Linguist::Client.version
    end

    def usage
      longest_command_length = self.class.groups.map do |group|
        group.map { |g| g.first.length }
      end.flatten.max

      self.class.groups.inject(StringIO.new) do |output, group|
        output.puts "=== %s" % group.title
        output.puts

        group.each do |command, description|
          if command.empty?
            output.puts
          else
            output.puts "%-*s # %s" % [longest_command_length, command, description]
          end
        end

        output.puts
        output
      end.string
    end
  end
end

Linguist::Command::Help.create_default_groups!
