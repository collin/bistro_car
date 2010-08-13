module BistroCar
  class Bundle
    attr_reader :name
    
    def initialize(name)
      @name = name.to_sym
    end
    
    def file_paths
      if manifest?
        manifest_paths
      else
        Dir.glob(path.join('*.coffee')).to_a
      end
    end
    
    def to_javascript
      minify(file_paths.map { |path| BistroCar.compile(path.to_s) }.join)
    end

    def manifest?
      File.exist? manifest_path
    end
    
    def manifest
      manifest_path.read
    end
    
    def manifest_path
      path + "manifest"
    end

    def manifest_paths
      manifest.lines.map do |line|
        path + "#{line}.coffee"
      end
    end

    def javascript_url
      "/javascripts/bundle/#{name}.js"
    end

  private

    def minify(javascript)
      if BistroCar.minify then JSMin.minify(javascript) else javascript end
    end
  
    def path
      if name == :default
        Rails.root.join('app/scripts')
      else
        Rails.root.join('app/scripts', name.to_s)
      end
    end
  end
end
