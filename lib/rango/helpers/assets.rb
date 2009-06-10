# encoding: utf-8

module Rango
  module Helpers
    # stolen from pupu (but it's OK, it's my code)
    # @since 0.0.2
    def javascript(basename)
      path = Path.new(File.join(Project.settings.media_root, "javascripts", "#{basename}.js"))
      tag :script, src: path.url, type: "text/javascript"
    end

    # @since 0.0.2
    def stylesheet(basename, attrs = Hash.new)
      path = Path.new(File.join(Project.settings.media_root, basename))
      default = {href: path.url, media: 'screen', rel: 'stylesheet', type: 'text/css'}
      single_tag :link, default.merge(attrs)
    end

    # @since 0.0.2
    def javascripts(*names)
      names.map { |name| self.javascript(name) }.join("\n")
    end

    # @since 0.0.2
    def stylesheets(*names)
      names.map { |name| self.stylesheet(name) }.join("\n")
    end
  end
end
