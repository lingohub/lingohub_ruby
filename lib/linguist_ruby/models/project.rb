module Linguist
  module Models
    require 'linguist_ruby/models/resource'
    require 'linguist_ruby/models/collaborator'

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

      lazy_attr_accessor(:title, :link, :weburl, :resources_url, :collaborators_url, :invitations_url, :translations_url, :translations_count, :owner)

      def initialize(client, link)
        @client = client
        @link = link
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

      def invite_collaborator(email)
        @client.post(self.invitations_url, :invitation => {:email => email})
      end

      def resources
        unless defined? @resources
          @resources = {}
          response = @client.get(self.resources_url)
          resource_hash = JSON.parse(response)
          members = resource_hash["resources"]["members"]
          members.each do |member|
            @resources[member["name"]] = Linguist::Models::Resource.new(@client, member["link"]["href"])
          end
        end
        @resources
      end

      def collaborators
        unless defined? @collaborators
          @collaborators = []
          response = @client.get(self.collaborators_url)
          resource_hash = JSON.parse(response)
          members = resource_hash["collaborators"]["members"]
          members.each do |member|
            link = member["link"]["href"] rescue ""
            collaborator = Linguist::Models::Collaborator.new(@client, link)
            collaborator.email = member["email"]
            collaborator.display_name = member["display_name"]
            collaborator.roles = member["roles"]
            @collaborators << collaborator
          end
        end
        @collaborators
      end

      def pull_resource(dir, file_name)
        raise "Project does not contain that file." unless self.resources.has_key?(file_name)
        save_to_file(File.join(dir, file_name), self.resources[file_name].content)
      end

      def push_resource(path, locale)
        raise "Path #{path} does not exists" unless File.exists?(path)
        request = { :file => File.new(path, "rb") }
        request.merge!({ :iso2_slug => locale }) if locale
        @client.post(self.resources_url, request)
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
        collaborators_url = links[4]["href"]
        invitations_url = links[5]["href"]
        init_attributes :title => project_hash["title"], :link => link, :weburl => weburl,
                        :owner => project_hash["owner_email"], :translations_count => project_hash["translations_count"],
                        :translations_url => translations_url, :resources_url => resources_url,
                        :collaborators_url => collaborators_url, :invitations_url => invitations_url
      end

      def init_attributes(attributes)
        attributes.each_pair do |key, value|
          unless self.instance_variable_get("@#{key}")
            self.send "#{key}=", value
          end
        end
      end

      def save_to_file(path, content)
        File.open(path, 'w+') { |f| f.write(content) }
      end

    end
  end
end