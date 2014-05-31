module FlickrUploader
  class Uploader
    attr_accessor :flickr, :sets

    def initialize(client)
      self.flickr = client.flickr
      self.sets = Hash[get_sets_info]
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
