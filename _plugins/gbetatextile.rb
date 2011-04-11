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
require 'cgi'
#
# module GbetaProgramTag
# 
module GbetaProgramTag
  include RedCloth::Formatters::HTML

  # ID class variable (for gbeta editors)
  @@id = 0

  # Prefix for all gbeta program code editors' id
  GBETA_PROGRAM_PREFIX = 'gbeta_program_'

  # Public: Inserts a gbeta programs using the textile command:
  #
  #   gbprog. [FILE]
  #
  # Example
  #
  #   gbprog. hello.gb
  #   # => (code editor with contents /gbeta-tutorial/gbsrc/hello.gb)
  #
  # Depends on CGI to escape HTML.
  #
  # Gives every gbeta program (that are found) a unique id by calling
  # the getUniqueId function.
  def gbprog(opts)
    fileName = "gbeta-tutorial/gbsrc/" + opts[:text]

    # Open and read file (if it exists)
    if File.exists?(fileName) && File.file?(fileName)
      content = File.open(fileName, 'rb') { |f| f.read }.strip
      html =  %Q{<form><textarea id="#{getUniqueId}" name="#{getUniqueId}">#{CGI::escapeHTML(content)}</textarea></form>\n}
      html << %Q{<input id="#{'compile_'+@@id.to_s}" class="compile" type="submit" value="Compile" title="Press [ENTER] to run the code" />\n}
      html << %Q{<div id="#{'error_' +@@id.to_s}"></div>}
      html << %Q{<div id="#{'output_'+@@id.to_s}"></div>}
      html << %Q{<!-- CodeMirror for gbeta program '#{fileName}'\n     with id '#{getUniqueId}' -->\n}
      # html << %Q{<script>\n  CodeMirror.fromTextArea(document.getElementById("#{getUniqueId}"), { lineNumbers: true });\n</script>\n}
      renewId
      html
    else
      html =  %Q{<pre class="block"><code class="block"><em>Figure not found: #{fileName}</em></code></pre>}
    end
  end

  private
  
  # Public: Constructs unique id for textarea
  def getUniqueId
    %Q{#{GBETA_PROGRAM_PREFIX + @@id.to_s}}
  end

  def renewId
    @@id += 1
  end
end
