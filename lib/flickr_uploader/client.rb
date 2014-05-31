require 'yaml'
require 'flickraw'

module FlickrUploader
  class Client
    attr_accessor :flickr, :token, :secret

    def initialize
      config_api
      authenticate
      LOG.debug "Flickr account set up"
    end

    def config_api
      LOG.debug "Config: API_KEY: #{Conf::API_KEY}"
      LOG.debug "Config: SHARED_SECRET: #{Conf::SHARED_SECRET}"
      FlickRaw.api_key = Conf::API_KEY
      FlickRaw.shared_secret = Conf::SHARED_SECRET
      self.flickr = FlickRaw::Flickr.new
    end

    def authenticate
      create_auth_file unless valid_auth_file?
      load_authentication
      authenticate unless valid_token?
    end

    def valid_auth_file?
      File.exists? Conf::AUTH_FILE
    end

    def create_auth_file
      LOG.debug "Authenticating"
      info = flickr.get_request_token
      request_token = info['oauth_token']
      request_secret = info['oauth_token_secret']
      verify_auth request_token, request_secret
      save_auth_info
    end

    def load_authentication
      LOG.debug "Loading cached authentication"
      auth_info = YAML::load(File.open(Conf::AUTH_FILE))
      self.token = flickr.access_token = auth_info[:token]
      self.secret = flickr.access_secret = auth_info[:secret]
    end

    def valid_token?
      begin
        true if flickr.test.login
      rescue
        LOG.debug "Stale token. Removing auth file."
        FileUtils.remove(Conf::AUTH_FILE)
        false
      end
    end

    def verify_auth(request_token, request_secret, perms = 'write')
      LOG.debug "Get URL for verification token"
      auth_url = flickr.get_authorize_url(request_token, :perms => perms)
      STDOUT.puts "Visit this URL to complete authentication: #{auth_url}"
      STDOUT.puts "When you're done, paste the verification code below."
      STDOUT.print "Verification code: "

      verification_code = STDIN.gets.strip
      flickr.get_access_token(request_token, request_secret, verification_code)
      self.token = flickr.access_token
      self.secret = flickr.access_secret
    end

    def save_auth_info
      auth_info = {token: self.token, secret: self.secret}
      File.open(Conf::AUTH_FILE, 'w') do |file|
        file.write(auth_info.to_yaml)
      end
    end
  end
end
