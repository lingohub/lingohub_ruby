module Linguist
  module Models
    require 'linguist/models/resource'

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

      lazy_attr_accessor(:title, :link, :weburl, :resources_url, :translations_url, :translations_count, :owner)

      def initialize(client, link)
        @client = client
        @link   = link
      end

      def create!(attributes={ })
        self.title = attribtes[:title]
      end

      def destroy
        @client.delete self.link
      end

      def update(attributes={ })
        @client.put self.link, { :project => attributes }
      end

      def resources
        unless defined? @resources
          @resources    = { }
          response      = @client.get(self.resources_url)
          resource_hash = JSON.parse(response)
          members = resource_hash["resources"]["members"]
          members.each do |member|
            member["link"].each do |link|
              file_name = link["rel"]
              locale, extension = File.basename(file_name, '.*'), File.extname(file_name)
              @resources[file_name] = Linguist::Models::Resource.new(@client, locale, extension, link["href"])
            end
          end
        end
        puts "RESOURCES #{@resources}"
        @resources
      end

      private

      def fetch
        @fetched = true
        response = @client.get @link
        project_hash = JSON.parse(response)
        links = project_hash["link"]
        link = links[0]["href"]
        weburl = links[1]["href"]
        translations_url = links[2]["href"]
        resources_url = links[3]["href"]
        init_attributes :title => project_hash["title"], :link => link, :weburl => weburl,
                        :owner => project_hash["owner_email"], :translations_count => project_hash["translations_count"],
                        :translations_url => translations_url, :resources_url => resources_url
      end

      def init_attributes(attributes)
        attributes.each_pair do |key, value|
          unless self.instance_variable_get("@#{key}")
            self.send "#{key}=", value
          end
        end
      end

    end
  end
end