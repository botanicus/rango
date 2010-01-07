# encoding: utf-8

# class Application < Rango::Controller
#   include Rango::ActionArgsMixin
# end

# def test(name, params = Hash.new, *args)
# end
# method(:test).parameters
# => [[:req, :name], [:opt, :params], [:rest, :args]]

if RUBY_VERSION < "1.9.2"
  begin
    require "methopara"
  rescue LoadError
    raise LoadError, "Method#parameters is part of Ruby 1.9.2 and higher. If you want to use this feature with Ruby 1.9.1, you have to install methopara gem (http://github.com/genki/methopara)"
  end
end

module Rango
  module ActionArgsMixin
    def invoke_action(action)
      view     = self.method(action)
      names    = view.parameters.map { |type, name| name }
      types    = view.parameters.map { |type, name| type }
      required = view.parameters.map { |type, name| name if type.eql?(:req) }.compact

      # validate types
      if types.include?(:rest)
        raise ArgumentError, "View can't have splat argument. Use just this: def #{action}(#{names[0..-2].join(", ")})"
      elsif types.include?(:block)
        raise ArgumentError, "View can't have block argument. Use just this: def #{action}(#{names[0..-2].join(", ")})"
      end

      # validate names
      unless (extra_keys = required - self.params.keys).empty?
        raise ArgumentError, "Following keys aren't available in params: #{extra_keys.inspect}\nAvailable keys: #{self.params.keys.inspect}"
      end

      args = Array.new
      view.parameters.each do |type, name|
        args.push(self.params[name]) if type.eql?(:req) || (type.eql?(:opt) && !self.params[name].nil?) # this is a bit complex, but we have to do because of rewriting optional args by nil value if we use just map with params[name]
      end
      puts "Rendering #{self.class}##{action} with #{args.map(&:inspect).join(", ")}"
      self.response.body = self.send(action, *args)
    end
  end
end
