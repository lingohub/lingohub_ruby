require 'rubygems'
require "rspec"

require 'lingohub'
require 'lingohub/command'

#require 'vcr'
#VCR.configure do |c|
#  c.cassette_library_dir = 'spec/cassettes'
#  c.hook_into :webmock
#  c.configure_rspec_metadata!
#end

RSpec.configure do |c|
  # so we can use `:vcr` rather than `:vcr => true`;
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true

  # support inclusion filter :focus
  c.filter_run_including :focus => true
  # will run all the examples when none match the inclusion filter
  c.run_all_when_everything_filtered = true
end

module Lingohub
  module Spec

    def self.projects
      Lingohub::Models::Projects.new(client)
    end

    def self.client
      Lingohub::Client.new(credentials)
    end

    #FIXME change this to something properly setup for spec runs
    def self.credentials
      {
        :username   => 'foo',
        :password   => 'bar',
        :auth_token => '89111d2469b74f7728a2bcee6b5bbb50ce25e13b435a60f9fbc4218e5a990045',
        :host       => 'localhost:3000'
      }
    end

    def self.project_link(title)
      "http://#{credentials[:host]}/api/v1/snusnu/#{title}"
    end

    def self.weburl(title)
      "http://#{credentials[:host]}/snusnu/#{title}/translations"
    end
  end
end

