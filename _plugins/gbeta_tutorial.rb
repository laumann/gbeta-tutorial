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
    end.each do           # take away line breaks
      |line| line.chomp!
    end.delete_if do      # delete empty lines and lines beginning with '#'
      |line| line !~ /\S/ or line.start_with? '#'
    end

    def render(context)
      # use url to find out what file we're working on
      # STDERR.puts context["page"]['url']
      file = context['page']['url'][/(\w*)\.html/].gsub /\.html/, ''

      # Get the file's index and return if this file is not in tutorial.conf
      return "" unless index = @@tutorial.index { |item| item == file }

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
