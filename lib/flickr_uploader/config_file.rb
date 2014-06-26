require 'yaml'

module FlickrUploader
  class ConfigFile
    def initialize(path, *required_keys)
      @path = path
      @required_keys = required_keys
      read_file
    end

    def [](key)
      @contents[key]
    end

    def write(contents)
      validate(contents)
      create_path
      File.open(@path, 'w') do |file|
        @contents = contents
        file.write(@contents.to_yaml)
      end
    end

    def remove
      FileUtils.remove(@path) if exists?
      @contents = {}
    end

    def valid?
      @required_keys.map { |key| has_key? key }.all?
    end

    private

    def has_key?(key)
      @contents.has_key? key
    end

    def validate(contents)
      raise YAML::Exception unless contents.is_a? Hash
    end

    def read_file
      begin
        @contents = YAML::load(File.open(@path)) if exists?
        validate(@contents)
      rescue
        remove
      end
    end

    def create_path
      FileUtils.makedirs(File.dirname(@path))
    end

    def exists?
      File.exists? @path
    end
  end
end
