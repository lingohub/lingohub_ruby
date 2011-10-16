module Linguist::Command
  class Collaborator < Base
    def list
      list = project.collaborators
      if list.size > 0
        display "Collaborators:\n"
        list.each { |c| display("- #{c.display_name} | #{c.email} | #{c.permissions}") }
      else
        display "No collaborators found"
      end
    end

    def invite
      email = extract_email_from_args
      project.invite_collaborator(email)

      display("Invitation sent to #{email}")
    rescue RestClient::BadRequest
      display("Error sending invitation to '#{email}'")
    end

    def remove
      email = extract_email_from_args
      collaborator = project.collaborators.find { |c| c.email == email }

      if collaborator.nil?
        display("Collaborator with email '#{email}' not found")
      else
        collaborator.destroy
        display("Collaborator with email #{email} was removed")
      end
    rescue RestClient::BadRequest
      display("Error removing collaborator with email '#{email}'")
    end

    private

    def extract_email_from_args
      email = args.shift
      raise(CommandFailed, "You must specify a invitee email after --email") if email == false
      email
    end
  end
end