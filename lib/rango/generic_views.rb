# encoding: utf-8

Rango.import("mixins/mini")

# http://gist.github.com/125500
class Rango
  module GenericViews
    include Rango::Mini

    @@generic ||= Array.new
    # GenericViews.add(:hello) do |request, reponse|
    #   [200, Hash.new, ["Hello Generic Views!"]]
    # end
    def self.add(name, &block)
      @@generic.push(name)
      define_method(name, &block)
      self.metaclass.send(:define_method, name) do
        extend Rango::Mini
        app(&block)
      end
    end
  end
end

Rango::GenericViews.add(:static) do |request, response|
  render request.path_info
end
