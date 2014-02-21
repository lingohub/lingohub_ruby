module Lingohub
  module Models
    class Resource
      attr_accessor :locale

      STRATEGY_UPDATE_AND_CREATE = 'update_and_create'
      STRATEGY_MASTER_LOCALE_STRUCTURE = 'master_locale_structure'
      STRATEGY_OVERRIDE ='override'
      STRATEGIES = [STRATEGY_MASTER_LOCALE_STRUCTURE, STRATEGY_UPDATE_AND_CREATE, STRATEGY_OVERRIDE]

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
