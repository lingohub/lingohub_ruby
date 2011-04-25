module Linguist
  module Models
    class Project
      def self.lazy_attr_accessor(*params)
        params.each do |sym|
          define_method(sym) do
            unless defined? @fetched
              fetch
            end
            self.instance_variable_get("@#{sym}")
          end
          define_method("#{sym}=") do |value|
            self.instance_variable_set("@#{sym}", value)
          end
        end
      end

      lazy_attr_accessor(:title, :link, :weburl, :translations_count, :owner)

      def initialize(client, link)
        @client = client
        @link   = link
      end

      def create!(attributes={})
        self.title = attribtes[:title]
      end

      def destroy
        @client.delete self.link
      end

      def update(attributes={})
        @client.put self.link, {:project => attributes}
      end

      private

      def fetch
        @fetched     = true
        response     = @client.get @link
        project_hash = JSON.parse(response)
        links        = project_hash["link"]
        link         = links[0]["href"]
        weburl       = links[1]["href"]
        init_attributes :title => project_hash["title"], :link => link, :weburl => weburl,
                        :owner => project_hash["owner_email"], :translations_count => project_hash["translations_count"]
      end

      def init_attributes(attributes)
        attributes.each_pair do |key, value|
          unless self.instance_variable_get("@#{key}")
            puts "SETTING #{key} to #{value}"
            self.send "#{key}=", value
          end
        end
      end

    end
  end
end