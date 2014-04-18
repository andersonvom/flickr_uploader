module FlickrUploader
  module Conf
    API_KEY="------------api_key-------------"
    SHARED_SECRET="-----secret-----"

    CONFIG_DIR = File.dirname(__FILE__)
    ROOT_DIR = File.absolute_path(File.join(CONFIG_DIR, '..'))
    LIB_DIR = File.join(ROOT_DIR, 'lib')
    LOG_DIR = File.join(ROOT_DIR, 'log')

    AUTH_FILE = File.join(CONFIG_DIR, 'flickr_auth.yaml')
  end
end
