# encoding: utf-8

Rango.import("mixins/mini")

# http://gist.github.com/125500
class Rango
  module GenericViews
    include Rango::Mini
    extend  Rango::Mini

    @@generic ||= Array.new
    # GenericViews.add(:hello) do |request, reponse|
    #   [200, Hash.new, ["Hello Generic Views!"]]
    # end
    def self.add(name, &block)
      @@generic.push(name)
      define_method(name, &block)
      self.metaclass.send(:define_method, :"__#{name}__", &block)
      self.metaclass.send(:define_method, name) do
        app do |*args|
          self.send(:"__#{name}__", *args)
        end
      end
    end
  end
end

Rango::GenericViews.add(:static) do |request, response|
  template = "#{request.script_name[1..-1]}.html"
  Rango.logger.debug("Rendering '#{template}'")
  render template
end
