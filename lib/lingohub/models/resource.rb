module Lingohub
  module Models
    class Resource
      attr_accessor :locale

      def initialize(client, locale, link)
        @client = client
        @locale = locale
        @link   = link
      end

      # Downloads the resource content
      def content
        @content ||= @client.get(@link)
      end
    end
  end
end
