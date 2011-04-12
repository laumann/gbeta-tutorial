
module Jekyll

  class GbetaFile < StaticFile
    def initialize(site, base, dir, name)
      @site, @base, @dir, @name = site, base, dir, name
    end

    #
    # {source}/_gbeta -> {site}/gbeta
    def destination(dest)
      File.join(dest, 'gbeta', @dir, @name)
    end

    # Write the static file to the destination directory (if
    #   modified). This function does the same as in StaticFile, but
    #   FileUtils.cp preserves the timestamp.
    #
    #   +dest+ is the String path to the destination dir
    #
    # Returns false if the file was not modified since last time (no-op).
    def write(dest)
      dest_path = destination(dest)

      return false if File.exist? dest_path and !modified?
      @@mtimes[path] = mtime

      FileUtils.mkdir_p(File.dirname(dest_path))
      FileUtils.cp(path, dest_path, :preserve => true)

      true
    end
  end

  class GbetaGenerator < Generator
    safe true

    priority :normal

    def setup
      return if @setup
      require 'fileutils'
    rescue LoadError
      STDERR.puts 'You are missing a library \'fileutils\''
      raise FatalException.new("Missing dependency: fileutils")
    end

    def initialize(config)
      @config = config
    end

    def generate(site)
      STDERR.print %Q{Generating gbeta: #{File.join(@config['source'], '_gbeta')}}
      STDERR.puts  %Q{ -> #{File.join(@config['destination'], 'gbeta')}}
      
      Dir['_gbeta/**/*'].each do |f|
        next unless File.file?(f)   # Skip non-files
        dir, name = File.split(f.sub('_gbeta/', ''))
        gbFile = GbetaFile.new(site,
                               File.join(site.source, '_gbeta'),
                               dir,
                               name)
        
        site.static_files << gbFile
      end
    end
  end

end
