require 'yaml'
require 'flickraw'


class Flickr
  attr_accessor :flickr, :token, :secret

  def initialize
    config_app

    authenticate
    $log.debug "Flickr account set up"
  end

  def config_app
    $log.debug "Configuring app"
    $log.debug "Config: API_KEY: #{Conf::API_KEY}"
    $log.debug "Config: SHARED_SECRET: #{Conf::SHARED_SECRET}"
    FlickRaw.api_key = Conf::API_KEY
    FlickRaw.shared_secret = Conf::SHARED_SECRET
    self.flickr = FlickRaw::Flickr.new
  end

  def authenticate
    $log.debug "Authenticating"
    info = flickr.get_request_token
    request_token = info['oauth_token']
    request_secret = info['oauth_token_secret']
    verify_auth request_token, request_secret
  end

  def verify_auth(request_token, request_secret, perms = 'write')
    $log.debug "Get URL for verification token"
    auth_url = flickr.get_authorize_url(request_token, :perms => perms)
    puts "Visit this URL to complete authentication: #{auth_url}"
    puts "When you're done, paste the verification code below."
    print "Verification code: "

    verification_code = gets.strip
    flickr.get_access_token(request_token, request_secret, verification_code)
    self.token = flickr.access_token
    self.secret = flickr.access_secret
  end

  def upload(file, set_name)
    $log.debug "Uploading #{file} to set #{set_name}"
  end
end
