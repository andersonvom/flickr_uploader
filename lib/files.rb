module Files

  def Files.set_walk(*paths)
    paths.each do |path|
      $log.debug "Yielding path"
      yield path, path
    end
  end

end
