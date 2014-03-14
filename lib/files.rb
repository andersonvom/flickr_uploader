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
      root_dir = File.absolute_path(path)
      $log.debug "Walking #{root_dir}"

      matcher = File.join(root_dir, '', '**', '*')
      files = Dir.glob(matcher)
      files.each do |file|
        next if File.directory? file

        set_name = Files.set_name(file, root_dir)
        $log.debug "Yield - Set: #{set_name} | File: #{file}"
        yield file, set_name
      end
    end
  end

end
