require 'yaml'


module FlickrUploader
  module Conf
    API_KEY="------------api_key-------------"
    SHARED_SECRET="-----secret-----"

    DOT_DIR = File.absolute_path(File.join('~', '.flickr_uploader'))
    API_FILE = File.join(DOT_DIR, 'flickr_api.yaml')
    AUTH_FILE = File.join(DOT_DIR, 'flickr_auth.yaml')
  end

  class Config
    DOT_DIR = File.absolute_path(File.join('~', '.flickr_uploader'))
    API_FILE = File.join(DOT_DIR, 'flickr_api.yaml')
    AUTH_FILE = File.join(DOT_DIR, 'flickr_auth.yaml')

    def self.flickr_api
      LOG.error "init"
      @@flickr_api ||= self.read_or_create_api_file
    end

    def self.read_or_create_api_file
      flickr_api = nil
      if File.exists? Config::API_FILE
        flickr_api = YAML.load Config::API_FILE
      else
        print "Enter your API key: "
        api_key = STDIN.gets.chomp
        print "Enter your API shared secret: "
        secret = STDIN.gets.chomp
        flickr_api = { api_key: api_key, shared_secret: secret }
        File.open Config::API_FILE do |file|
          file.write flickr_api.to_yaml
        end
      end
      flickr_api
    end
  end
end
