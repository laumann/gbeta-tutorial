#
# Add support for markup syntax (textile)
#
# I want to use textile's formatting capabilities (instead of
# implementing my own converter from the bottom), so I can use
# commands like "gbprog. hello.gb". Therefore I will extend
# RedCloth with extra commands and use the extension '.gbt' to
# identify these special files
#
# Example:
# gbprog. hello.gb

module Jekyll

  class GbetaTextile < Converter
    safe true

    pygments_prefix '<notextile>'
    pygments_suffix '</notextile>'

    priority :low

    def setup
      return if @setup
      require 'redcloth'
    rescue LoadError
      STDERR.puts 'You are missing a library required for Textile. Please run:'
      STDERR.puts '  $ [sudo] gem install RedCloth'
      raise FatalException.new("Missing dependency: RedCloth")
    end
    
    def matches(ext)
      ext =~/gbt/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      setup
      r = RedCloth.new(content)
      r.extend GbetaProgramTag
      r.hard_breaks = false
      r.to_html
    end
  end
end

require 'redcloth'
#
# module GbetaProgramTag
# 
#
module GbetaProgramTag
  include RedCloth::Formatters::HTML

  #
  # TODO: Write nicer and implement _real_ code box
  def gbprog(opts)
    fileName = "gbeta-tutorial/gbsrc/" + opts[:text]

    # Check file existence
    # raise %Q{Not found: #{fileName}} unless File.exists?(fileName)
    # raise %Q{Not a file: #{fileName}} unless File.file?(fileName)

    # Open and read file
    if File.exists?(fileName) && File.file?(fileName)
      content = File.open(fileName, 'rb') { |f| f.read }
      html = %Q{<p><pre><code>#{content.strip}</code></pre><p>}
    else
      html = %Q{<p><pre><code><em>Figure not found: #{fileName}</em></code></pre></p>}
    end
  end
end
