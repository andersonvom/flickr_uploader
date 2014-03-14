require 'logger'

module Conf
  API_KEY="------------api_key-------------"
  SHARED_SECRET="-----secret-----"

  CONFIG_DIR = File.dirname(__FILE__)
  ROOT_DIR = File.absolute_path(File.join(CONFIG_DIR, '..'))
  LIB_DIR = File.join(ROOT_DIR, 'lib')
  LOG_DIR = File.join(ROOT_DIR, 'log')

  AUTH_FILE = File.join(CONFIG_DIR, 'flickr_auth.yaml')
  LOG_FILE = File.join(LOG_DIR, 'flickr-uploadr.log')
end

$log = Logger.new(Conf::LOG_FILE)
$log.level = Logger::INFO

Dir.glob(File.join(Conf::CONFIG_DIR, '*.rb')).each do |lib|
  $log.debug "Loading #{lib}"
  require lib
end

Dir.glob(File.join(Conf::LIB_DIR, '*.rb')).each do |lib|
  $log.debug "Loading #{lib}"
  require lib
end
