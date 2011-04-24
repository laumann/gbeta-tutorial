

module Jekyll
  class RenderTimeTag < Liquid::Tag
    
    def initialize(tag, text, tokens)
      super
      @text = text;
    end

    def render(contex)
      "#{@text} #{Time.now}"
    end
  end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)
