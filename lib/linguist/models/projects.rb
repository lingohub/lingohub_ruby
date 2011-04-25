module Linguist
  module Models
    require 'linguist/models/project'

    class Projects

      PROJECT_URL = '/projects'

      def initialize(client)
        @client   = client
      end

      def create(title)
        @client.post(PROJECT_URL, :project => {:title => title})
      end

      def all
        return @projects if defined? @projects
        @projects = {}
        response = JSON.parse @client.get(PROJECT_URL).to_s
        response["projects"]["members"].each do |member|
          project = Linguist::Models::Project.new(@client, member["link"][0]["href"])
          @projects[member["title"]] = project
        end
        @projects
      end

      def [](project_title)
        return all[project_title]
      end

    end
  end
end
