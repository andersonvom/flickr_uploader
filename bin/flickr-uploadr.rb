current_dir = File.dirname(__FILE__)
env_file = File.join(current_dir, '..', 'config', 'environment.rb')
require File.absolute_path(env_file)

paths = ARGV
flickr_account = Flickr.new
Files.set_walk(*paths) do |file, set_name|
  flickr_account.upload(file, set_name)
end
