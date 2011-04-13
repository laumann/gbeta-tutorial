#
# Any file that uses the 'gbeta' layout are subject to parsing by this
# parser. Render will:
#  - whenever the {% gbeta_tutorial %} liquid tag is encountered, find
#    out if the current file is part of the tutorial (by using
#    context['page']['url']).
#  - If so, output the tutorial pager (wrapped in a div tag with id
#    'pager') 
module Jekyll

  # Public: loads /tutorial/tutorial.conf into an array and removes line
  # breaks and comments.
  #
  # Tutorial is thus globally defined within the Jekyll module
  Tutorial = File.open("tutorial/tutorial.conf", 'r') do |file|
    file.readlines
  end.each do |line|       # take away line breaks
    line.chomp!
  end.delete_if do |line|  # delete empty lines and lines beginning with '#'
    line !~ /\S/ or line.start_with? '#'
  end

  # the {% gbeta_tutorial [next|prev|first] %} liquid tag
  class GbetaTutorialTag < Liquid::Tag

    # We allow an optional word (next, prev or first)
    SYNTAX = /(next|prev|first)?\s?/

    def initialize(tag_name, command, extra)
      super
      if command =~ SYNTAX
        #STDERR.puts %Q{Matched SYNTAX: Got '#{$1}'}
        @command = $1
      else
        #STDERR.puts %Q{Got '#{command}'}
        raise SyntaxError.new("Syntax Error in 'gbeta_tutorial' - Valid syntax: gbeta_tutorial [next|prev|first]")
      end
    end

    def render(context)
      # use url to find out what file we're working on
      # STDERR.puts context["page"]['url']
      file = context['page']['url'][/(\w*)\.html/].gsub /\.html/, ''

      case @command
      when 'next'
        raise "Error: 'next' command used outside tutorial" unless index = Tutorial.index { |item| item == file }
        raise "Error: 'next' command used in first file of tutorial'" if index==Tutorial.length-1
        '/tutorial/' + Tutorial[index+1] + '.html'
      when 'prev'
        raise "Error: 'prev' command used outside tutorial" unless index = Tutorial.index { |item| item == file }
        raise "Error: 'prev' command used in first file of tutorial'" if index==0
        '/tutorial/' + Tutorial[index-1] + '.html'
      when 'first'
        '/tutorial/' + Tutorial[0] + '.html'
      else
        # No argument given
        # Get the file's index and return if this file is not in tutorial.conf
        return "" unless index = Tutorial.index { |item| item == file }
        
        # Put together the pager - calculating width as 19px per link
        html    = %Q{<div id="pager" style="width: #{Tutorial.length*19}px">}
        Tutorial.each_index do |idx|
          html << %Q{<a href="/tutorial/#{Tutorial[idx]}.html"}
          html << %Q{ class="active"} if idx==index
          html << %Q{>#{idx+1}</a>}
        end
        html   << %Q{</div>}
      end
    end
  end
end

# Register the tag
Liquid::Template.register_tag('gbeta_tutorial', Jekyll::GbetaTutorialTag)
