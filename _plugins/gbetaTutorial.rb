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

  # the {% gbeta_tutorial %} liquid tag
  class GbetaTutorialTag < Liquid::Tag

    def render(context)
      # use url to find out what file we're working on
      # STDERR.puts context["page"]['url']
      file = context['page']['url'][/(\w*)\.html/].gsub /\.html/, ''

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

# Register the tag
Liquid::Template.register_tag('gbeta_tutorial', Jekyll::GbetaTutorialTag)
