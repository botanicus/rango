# encoding: utf-8

# TODO: javascript "application" => media/javascripts/application.js
# ... but what if I need full path? It should be tested if file exist, of course
# javascript Path.new("design/whatever.js")
module Rango
  module Helpers
    # stolen from pupu (but it's OK, it's my code)
    # @since 0.0.2
    def javascript(basename)
      path = MediaPath.new(File.join(Project.settings.media_root, "javascripts", "#{basename}.js"))
      tag :script, src: path.url, type: "text/javascript"
    end

    # @since 0.0.2
    def stylesheet(basename, attrs = Hash.new)
      path = MediaPath.new(File.join(Project.settings.media_root, "stylesheets", basename))
      default = {href: path.url, media: 'screen', rel: 'stylesheet', type: 'text/css'}
      single_tag :link, default.merge(attrs)
    end

    def image(basename, attrs = Hash.new)
      path = MediaPath.new(File.join(Project.settings.media_root, "images", basename))
      default = {src: path.url, alt: path.basename}
      single_tag :img, default.merge(attrs)
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
