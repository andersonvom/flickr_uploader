require 'flickraw'

module FlickrUploader
  class Client
    attr_accessor :flickr

    def initialize
      @auth_info = ConfigFile.new(Conf::AUTH_FILE)
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
      flickr.access_token = @auth_info[:token]
      flickr.access_secret = @auth_info[:secret]
      authenticate unless valid_token?
    end

    def valid_auth_file?
      @auth_info.has_key?(:token) and @auth_info.has_key?(:secret)
    end

    def create_auth_file
      LOG.debug "Authenticating"
      info = flickr.get_request_token
      req_token, req_secret = info['oauth_token'], info['oauth_token_secret']
      verification_code = get_verification_code(req_token, req_secret)
      info = get_auth_info(req_token, req_secret, verification_code)
      @auth_info.write(info)
    end

    def valid_token?
      begin
        true if flickr.test.login
      rescue
        LOG.debug "Stale token. Removing auth file."
        @auth_info.remove
        false
      end
    end

    def get_verification_code(request_token, request_secret, perms = 'write')
      LOG.debug "Get URL for verification token"
      auth_url = flickr.get_authorize_url(request_token, :perms => perms)
      STDOUT.puts "Visit this URL to get your verification code: #{auth_url}"
      STDOUT.print "Verification code: "
      STDIN.gets.strip
    end

    def get_auth_info(req_token, req_secret, verification_code)
      flickr.get_access_token(req_token, req_secret, verification_code)
      {token: flickr.access_token, secret: flickr.access_secret}
    end
  end
end
