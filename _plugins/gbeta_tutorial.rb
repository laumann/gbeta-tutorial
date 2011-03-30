#
# Any file that uses the 'gbeta' layout are subject to parsing by this
# parser. Render will:
#  - open /gbeta-tutorial/tutorial.conf (which contains an ordered
#    list of files to include in the tutorial).
#  - whenever the {% gbeta_tutorial %} liquid tag is encountered, find
#    out if the current file is part of the tutorial (by using
#    context['page']['url']).
#  - If so, output the tutorial pager (wrapped in a div tag with id
#    'pager') 
module Jekyll

  # the {% gbeta_tutorial %} liquid tag
  class GbetaTutorialTag < Liquid::Tag
    
    # load /gbeta-tutorial/tutorial.conf into an array and remove
    # line breaks 
    @@tutorial = File.open("gbeta-tutorial/tutorial.conf", 'r') do |file|
      file.readlines
    end.each { |entry| entry.chomp! }

    def render(context)

      # Find out what file we're in
      # STDERR.puts @tutorial
      # if current file is in @tutorial

      # use url
      # STDERR.puts context["page"]['url']
      # TODO: write nicer
      file = ""
      context['page']['url'].scan(/\/(\w*)*\.html/).each do |m|
        file = m[0]
      end

      # Get the file's index
      index = @@tutorial.index { |item| item==file }
      
      return "" if index.nil?           # return nothing if this file is not in tutorial.conf

      # build the html string to return, wrapped in a div tag
      html = %Q{<div id="pager">PAGE<br/>}

      case index
      when 0
        # Omit the 'back' button
        html << %Q{<&nbsp;1&nbsp;/&nbsp;#{@@tutorial.length}&nbsp;}
        html << %Q{<a href="/gbeta-tutorial/#{@@tutorial[1]}.html">></a>}
      when @@tutorial.length-1
        # Omit the 'forward' button
        html << %Q{<a href="/gbeta-tutorial/#{@@tutorial[index-1]}.html"><</a>}
        html << %Q{&nbsp;#{@@tutorial.length}&nbsp;/&nbsp;#{@@tutorial.length}&nbsp;>}
      else
        # normal - both 'back' and 'forward' button
        html << %Q{<a href="/gbeta-tutorial/#{@@tutorial[index-1]}.html"><</a>}
        html << %Q{&nbsp;#{index+1}&nbsp;/&nbsp;#{@@tutorial.length}&nbsp;}
        html << %Q{<a href="/gbeta-tutorial/#{@@tutorial[index+1]}.html">></a>}
      end

      html << %Q{</div>}
    end
  end
end

# Register the tag
Liquid::Template.register_tag('gbeta_tutorial', Jekyll::GbetaTutorialTag)
