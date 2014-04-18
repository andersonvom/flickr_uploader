require 'yaml'
require 'flickraw'

module FlickrUploader
  class Uploader
    attr_accessor :flickr, :token, :secret, :sets

    def initialize
      config_app

      if File.exists? Conf::AUTH_FILE
        load_authentication
      else
        authenticate
      end
      self.sets = Hash[get_sets_info]
      LOG.debug "Flickr account set up"
    end

    def config_app
      LOG.debug "Configuring app"
      LOG.debug "Config: API_KEY: #{Conf::API_KEY}"
      LOG.debug "Config: SHARED_SECRET: #{Conf::SHARED_SECRET}"
      FlickRaw.api_key = Conf::API_KEY
      FlickRaw.shared_secret = Conf::SHARED_SECRET
      self.flickr = FlickRaw::Flickr.new
    end

    def load_authentication
      LOG.debug "Loading cached authentication"
      auth_info = YAML::load(File.open(Conf::AUTH_FILE))
      if auth_info
        self.token = auth_info[:token]
        self.secret = auth_info[:secret]
        flickr.access_token = token
        flickr.access_secret = secret
        check_token_validity
      else
        LOG.debug "Unable to read cached auth info. Re-authenticating."
        authenticate
      end
    end

    def check_token_validity
      begin
        true if flickr.test.login
      rescue
        LOG.debug "Stale token. Re-authenticating."
        authenticate
      end
    end

    def authenticate
      LOG.debug "Authenticating"
      info = flickr.get_request_token
      request_token = info['oauth_token']
      request_secret = info['oauth_token_secret']
      verify_auth request_token, request_secret
      save_auth_info
    end

    def verify_auth(request_token, request_secret, perms = 'write')
      LOG.debug "Get URL for verification token"
      auth_url = flickr.get_authorize_url(request_token, :perms => perms)
      puts "Visit this URL to complete authentication: #{auth_url}"
      puts "When you're done, paste the verification code below."
      print "Verification code: "

      verification_code = gets.strip
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

    def get_sets_info
      LOG.debug "Retrieving sets information."
      set_list = flickr.photosets.getList
      LOG.debug "#{set_list.size} sets retrieved."
      set_list.map { |set| [set.title, set.id] }
    end

    def add_to_set(photo_id, set_name)
      set_id = sets[set_name]
      if set_id
        LOG.debug "Adding '#{photo_id}' to set '#{set_name}'"
        flickr.photosets.addPhoto photoset_id: set_id, photo_id: photo_id
      else
        LOG.debug "Set '#{set_name}' not found. Creating it with '#{photo_id}'."
        set = flickr.photosets.create title: set_name, primary_photo_id: photo_id
        self.sets[set_name] = set['id']
      end
    end

    def upload(file, set_name)
      begin
        LOG.info "Uploading '#{set_name}/ #{file}'"
        photo_id = flickr.upload_photo file, is_public: 0
        add_to_set photo_id, set_name
      rescue
        LOG.error "Unable to upload '#{set_name}/ #{file}'"
        LOG.error "Reason: #{$!}"
      end
    end

    def upload_dirs(dirs, extensions)
      FlickrUploader::Files.set_walk(*dirs, extensions) do |file, set_name|
        upload(file, set_name)
      end
    end
  end
end
