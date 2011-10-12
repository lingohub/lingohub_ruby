module Linguist
  module Models
    class Collaborator
      attr_accessor :email, :display_name, :roles

      ROLES_NAMES = { "project_admin" => "Project admin", "developer" => "Developer" }

      def initialize(client, link)
        @client = client
        @link = link
      end

      def destroy
        @client.delete @link
      end

      def permissions
        return "None" if self.roles.nil? or self.roles.empty?

        self.roles.find_all { |role| ROLES_NAMES.has_key?(role) }.join(", ")
      end

    end
  end
end
