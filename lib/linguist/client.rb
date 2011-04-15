require 'rest_client'
require 'uri'
require 'time'
require 'linguist/version'
require 'vendor/okjson'
require 'json'
require 'linguist/models/projects'

# A Ruby class to call the Linguist REST API.  You might use this if you want to
# manage your Linguist apps from within a Ruby program, such as Capistrano.
#
# Example:
#
#   require 'linguist'
#   linguist = Linguist::Client.new('me@example.com', 'mypass')
#   linguist.create('myapp')
#
class Linguist::Client

  def self.version
    Linguist::VERSION
  end

  def self.gem_version_string
    "linguist-gem/#{version}"
  end

  attr_accessor :host, :user, :auth_token

  def self.auth(user, password, host='lingui.st')
    client = new(user, password, host)
    OkJson.decode client.post('/sessions', { :email => user, :password => password }, :accept => 'json').to_s
  end

  def initialize(user, auth_token, host='lingui.st')
    @user       = user
    @auth_token = auth_token
    @host       = host
  end

  def projects
    return Linguist::Models::Projects.new(self)
  end

  def get(uri, extra_headers={ }) # :nodoc:
    process(:get, uri, extra_headers)
  end

  def post(uri, payload="", extra_headers={ }) # :nodoc:
    process(:post, uri, extra_headers, payload)
  end

  def put(uri, payload, extra_headers={ }) # :nodoc:
    process(:put, uri, extra_headers, payload)
  end

  def delete(uri, extra_headers={ }) # :nodoc:
    process(:delete, uri, extra_headers)
  end

  def process(method, uri, extra_headers={ }, payload=nil)
    headers = linguist_headers.merge(extra_headers)
#    payload  = auth_params.merge(payload)
    args     = [method, payload, headers].compact
    response = resource(uri).send(*args)

    puts "RESPONSE #{response}"

#    extract_warning(response)
    response
  end

  def resource(uri)

    RestClient.proxy = ENV['HTTP_PROXY'] || ENV['http_proxy']
    if uri =~ /^https?/
#      RestClient::Resource.new(uri, user, auth_token)
      RestClient::Resource.new(uri)
    elsif host =~ /^https?/
#      RestClient::Resource.new(host, user, auth_token)[uri]
      RestClient::Resource.new(host)[uri]
    else
#      RestClient::Resource.new("https://api.#{host}", user, password)[uri]
#      RestClient::Resource.new("http://localhost:3000/api/v1", user, auth_token)[uri]
      RestClient::Resource.new("http://localhost:3000/api/v1")[uri]
    end
  end

  def extract_warning(response)
#    return unless response
#    if response.headers[:x_heroku_warning] && @warning_callback
#      warning             = response.headers[:x_heroku_warning]
#      @displayed_warnings ||= { }
#      unless @displayed_warnings[warning]
#        @warning_callback.call(warning)
#        @displayed_warnings[warning] = true
#      end
#    end
  end

  def linguist_headers # :nodoc:
    {
      'X-Linguist-API-Version'     => '1',
      'X-Linguist-User-Email'      => user,
      'X-Linguist-User-Auth-Token' => auth_token,
      'User-Agent'                 => self.class.gem_version_string,
      'X-Ruby-Version'             => RUBY_VERSION,
      'X-Ruby-Platform'            => RUBY_PLATFORM,
      'content_type'               => 'json',
      'accept'                     => 'json'
    }
  end

end
