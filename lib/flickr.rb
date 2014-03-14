require 'yaml'
require 'flickraw'


class Flickr
  def upload(file, set_name)
    $log.debug "Uploading #{file} to set #{set_name}"
  end
end
