module Files

  def Files.set_name(file, root_dir)
    current_dir = File.dirname(file)
    set_name = current_dir.gsub(/#{root_dir}[\/]?/, '').gsub('/', '-')
    if set_name.empty?
      set_name = File.basename current_dir
    end
    set_name
  end

  def Files.set_walk(*paths)
    paths.each do |path|
      $log.debug "Yielding path"
      yield path, path
    end
  end

end
