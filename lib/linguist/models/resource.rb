module Linguist
  module Models
    class Resource
      attr_reader :locale, :format, :link

      # @param client [Linguist::Client] passed through client instance
      # @param locale [String]  String that represents a locale in ISO 2 format, e.g. 'en', 'de'
      # @param format [String]  Extension of the file format, e.g. 'en', 'de'
      # @param link [String]  Link to the resource, e.g. 'http://lvh.me:3000/api/v1/projects/project-1/resources/de.properties'
      def initialize(client, locale, format, link)
        @client = client
        @link   = link
        @locale = locale
        @format = format
      end

      # Downloads the resource and creates the new resource file. Overrides existing files.
      # @param dir [String] The directory where to store the file, e.g. '/Users/heli' would create a file '/Users/heli/en.yml'
      def download(dir)
        response = @client.get(link)
        File.open(dir + "/#{locale}#{format}", 'w+') { |f| f.write(response) }
      end

    end
  end
end
