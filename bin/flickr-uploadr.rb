#!/usr/bin/env ruby

current_dir = File.dirname(__FILE__)
env_file = File.join(current_dir, '..', 'config', 'environment.rb')
require File.absolute_path(env_file)

paths = ARGV
extensions = ['jpg', 'JPG', 'png', 'PNG']
flickr_account = Flickr.new
Files.set_walk(*paths, extensions) do |file, set_name|
  flickr_account.upload(file, set_name)
end
