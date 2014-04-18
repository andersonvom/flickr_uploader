module FlickrUploader
  module Files
    def Files.set_name(file, root_dir)
      current_dir = File.dirname(file)
      set_name = current_dir.gsub(/#{root_dir}[\/]?/, '').gsub('/', '-')
      if set_name.empty?
        set_name = File.basename current_dir
      end
      set_name
    end

    def Files.get_file_list(root_dir, extensions)
      matcher = File.join(root_dir, '', '**', '*')
      files = []
      extensions.each do |ext|
        files += Dir.glob(matcher + ".#{ext}")
      end
      files.sort
    end

    def Files.set_walk(*paths, extensions)
      paths.each do |path|
        root_dir = File.absolute_path(path)
        LOG.info "Walking #{root_dir}"

        files = Files.get_file_list root_dir, extensions
        files.each do |file|
          next if File.directory? file

          set_name = Files.set_name(file, root_dir)
          LOG.debug "Yield - Set: #{set_name} | File: #{file}"
          yield file, set_name
        end
      end
    end
  end
end
