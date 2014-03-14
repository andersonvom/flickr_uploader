require 'yaml'
require 'flickraw'


class Flickr
  attr_accessor :flickr

  def initialize
    config_app
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

  def upload(file, set_name)
    $log.debug "Uploading #{file} to set #{set_name}"
  end
end
