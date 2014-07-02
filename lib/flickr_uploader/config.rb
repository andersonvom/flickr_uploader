module FlickrUploader
  module Conf
    API_KEY="c03da870260cbaa5f647702a48b16e86"
    SHARED_SECRET="0dbc9eb92b564aa3"

    DOT_DIR = File.join(Dir.home, '.flickr_uploader')
    API_FILE = File.join(DOT_DIR, 'flickr_api.yaml')
    AUTH_FILE = File.join(DOT_DIR, 'flickr_auth.yaml')

    NUM_RETRIES = 3
  end
end
