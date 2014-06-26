class Fixnum
  def tries(&block)
    remaining = self
    begin
      block.call()
    rescue
      FlickrUploader::LOG.error "Failed.  Reason: #{$!}"
      remaining -= 1
      if remaining > 0
        FlickrUploader::LOG.error "Retrying (#{remaining - 1} left)..."
        retry
      end
    end
  end
end
