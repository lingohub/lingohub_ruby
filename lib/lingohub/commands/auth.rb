require "lingohub/client"

module Lingohub::Command
  class Auth < Base
    attr_accessor :credentials

    def client
      @client ||= init_lingohub
    end

    def init_lingohub
      client = Lingohub::Client.new(:username => user, :auth_token => auth_token, :host => host)
#      client.on_warning { |msg| self.display("\n#{msg}\n\n") }
      client
    end

    def host
      ENV['LINGOHUB_HOST'] || 'https://api.lingohub.com'
    end

    # just a stub; will raise if not authenticated
    def check
      client.projects.all
    end

    def reauthorize
      @credentials = ask_for_and_save_credentials
    end

    def user # :nodoc:
      get_credentials
      @credentials[0]
    end

    def auth_token # :nodoc:
      get_credentials
      @credentials[1]
    end

    def credentials_file
      "#{home_directory}/.lingohub/credentials"
    end

    def get_credentials # :nodoc:
      return if @credentials
      unless @credentials = read_credentials
        ask_for_and_save_credentials
      end
      @credentials
    end

    def read_credentials
      File.exist?(credentials_file) and File.read(credentials_file).split("\n")
    end

    def echo_off
      system "stty -echo"
    end

    def echo_on
      system "stty echo"
    end

    def ask_for_credentials
      puts "Enter your Lingohub credentials."

      print "Email: "
      user = ask


      print "Password  (please leave blank if you want to use your API token): "
      password = running_on_windows? ? ask_for_password_on_windows : ask_for_password

      if password.empty?
        print "API key: "
        api_key = ask
      else
        api_key = retrieve_api_key(password, user)
      end

      [user, api_key]
    end

    def retrieve_api_key(password, user)
      Lingohub::Client.auth(:username => user, :password => password, :host => host)['api_key']
    end

    def ask_for_password_on_windows
      require "Win32API"
      char = nil
      password = ''

      while char = Win32API.new("crtdll", "_getch", [], "L").Call do
        break if char == 10 || char == 13 # received carriage return or newline
        if char == 127 || char == 8 # backspace and delete
          password.slice!(-1, 1)
        else
          # windows might throw a -1 at us so make sure to handle RangeError
          (password << char.chr) rescue RangeError
        end
      end
      puts
      return password
    end

    def ask_for_password
      echo_off
      password = ask
      puts
      echo_on
      return password
    end

    def ask_for_and_save_credentials
      begin
        @credentials = ask_for_credentials
        write_credentials
        check
      rescue ::RestClient::Unauthorized, ::RestClient::ResourceNotFound => e
        puts "EXCEPTION #{e}"
        delete_credentials
        @client = nil
        @credentials = nil
        display "Authentication failed."
        retry if retry_login?
        exit 1
      rescue Exception => e
        delete_credentials
        raise e
      end
    end

    def retry_login?
      @login_attempts ||= 0
      @login_attempts += 1
      @login_attempts < 3
    end

    def write_credentials
      FileUtils.mkdir_p(File.dirname(credentials_file))
      f = File.open(credentials_file, 'w')
      f.chmod(0600)
      f.puts self.credentials
      f.close
      set_credentials_permissions
    end

    def set_credentials_permissions
      FileUtils.chmod 0700, File.dirname(credentials_file)
      FileUtils.chmod 0600, credentials_file
    end

    def delete_credentials
#      FileUtils.rm_f(credentials_file)
    end
  end
end
