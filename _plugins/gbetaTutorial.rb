#
# Liquid tags for Jekyll associated with the gbeta-tutorial project
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

  # The {% gbeta <version|rev> %} liquid tag. The values of version
  # and rev should be updated whenever they change in the gbeta svn
  # repo.
  class GbetaTag < Liquid::Tag
    GBETA_VERSION  = '1.9.11'
    GBETA_REVISION = '3089'

    OPTS = %w(version rev).join('|')

    def initialize(tag_name, command, extra)
      super
      if command =~ /\A(#{OPTS})\s?\z/
        @command = $1
      else
        raise SyntaxError.new("Syntax Error in 'gbeta' - Valid syntax: gbeta [#{OPTS}]")
      end
    end

    def render(context)
      case @command
      when 'version'
        GBETA_VERSION
      when 'rev'
        GBETA_REVISION
      end
    end
  end

  # the {% gbeta_tutorial [next|prev|first] %} liquid tag
  class GbetaTutorialTag < Liquid::Tag
    
    # The folder in which the gbeta tutorial is found
    TUT_FOLDER = '/tutorial/'
    
    # We allow an optional word (next, prev or first)
    OPTS = ['next', 'prev', 'first'].join('|')

    def initialize(tag_name, command, extra)
      super
      if command =~ /\A(#{OPTS})?\s?\z/
        @command = $1
      else
        raise SyntaxError.new("Syntax Error in 'gbeta_tutorial' - Valid syntax: gbeta_tutorial [#{OPTS}]")
      end
    end

    def render(context)
      # use url to find out what file we're working on
      # STDERR.puts context["page"]['url']
      file = context['page']['url'][/(\w*)\.html/].gsub /\.html/, ''

      case @command
      when 'next'
        raise ArgumentError.new("'next' command used outside tutorial") unless index = Tutorial.index { |item| item == file }
        raise IndexError.new("'next' command used in last file of tutorial") if index == Tutorial.length-1
        TUT_FOLDER + Tutorial[index+1] + '.html'
      when 'prev'
        raise ArgumentError.new("'prev' command used outside tutorial") unless index = Tutorial.index { |item| item == file }
        raise IndexError.new("'prev' command used in first file of tutorial'") if index == 0
        TUT_FOLDER + Tutorial[index-1] + '.html'
      when 'first'
        TUT_FOLDER + Tutorial[0] + '.html'
      else
        # No argument given
        # Get the file's index and return if this file is not in tutorial.conf
        return "" unless index = Tutorial.index { |item| item == file }
        
        # Put the pager together - calculating width as 19px per link
        html    = %Q{<div id="pager" style="width: #{Tutorial.length*19}px">}
        Tutorial.each_index do |idx|
          html << %Q{<a href="#{TUT_FOLDER + Tutorial[idx]}.html"}
          html << %Q{ class="active"} if idx == index
          html << %Q{>#{idx+1}</a>}
        end
        html   << %Q{</div>}
      end
    end
  end
end

# Register the tags
Liquid::Template.register_tag('gbeta_tutorial', Jekyll::GbetaTutorialTag)
Liquid::Template.register_tag('gbeta', Jekyll::GbetaTag)
