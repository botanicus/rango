# coding=utf-8

class Rango
  module Helpers
    # stolen from pupu (but it's OK, it's my code)
    def javascript(basename)
      path = Path.new(File.join(Project.settings.media_root, "javascripts", "#{basename}.js"))
      "<script src='#{path.url}' type='text/javascript'></script>"
    end

    def stylesheet(basename, params = Hash.new)
      path = Path.new(File.join(Project.media_root, basename))
      default = {media: 'screen', rel: 'stylesheet', type: 'text/css'}
      params = default.merge(params)
      "<link href='#{path.url}' #{params.to_html_attrs} />"
    end

    def javascripts(*names)
      names.map { |name| self.javascript(name) }.join("\n")
    end

    def stylesheets(*names)
      names.map { |name| self.stylesheet(name) }.join("\n")
    end

    def copyright(from)
      now = Time.now.year
      now.eql?(from) ? now : "#{from} - #{now}"
    end

    def textile(text)
      require "redcloth"
    end

    def markdown(text)
      require "bluecloth"
    end

    def maruku(text, options = Hash.new)
      require "maruku"
    end

    def syntax(text, options = Hash.new)
      require "syntax/convertors/html"
      convertor = Syntax::Convertors::HTML.for_syntax(options[:language] || "ruby")
      convertor.convert(text, false)
    end
  end
end