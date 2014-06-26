module FlickrUploader
  module Conf
    API_KEY="------------api_key-------------"
    SHARED_SECRET="-----secret-----"

    DOT_DIR = File.join(Dir.home, '.flickr_uploader')
    API_FILE = File.join(DOT_DIR, 'flickr_api.yaml')
    AUTH_FILE = File.join(DOT_DIR, 'flickr_auth.yaml')
  end
end
