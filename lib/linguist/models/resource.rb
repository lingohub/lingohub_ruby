module Linguist
  module Models
    class Resource
      def initialize(client, link)
        @client = client
        @link   = link
      end

      # Downloads the resource content
      def content
        @content ||= @client.get(@link)
      end
    end
  end
end
