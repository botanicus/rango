# encoding: utf-8

# class Application < Rango::Controller
#   include Rango::ActionArgsMixin
# end

# def test(name, params = Hash.new, *args)
# end
# method(:test).parameters
# => [[:req, :name], [:opt, :params], [:rest, :args]]

unless Kernel.method(:require).respond_to?(:parameters)
  raise <<-EOF
For action args mixin you need to have Method#parameters defined. This method is defined in 1.9.2 and higher or you can use genkhi/methopara on GitHub to get it working in Ruby 1.9.1, if it will work, but it never did for me.
  EOF
end

module Rango
  module ActionArgsMixin
    def invoke_action(action)
      view       = self.method(action)
      parameters = view.parameters.map! { |type, name| [type, name.to_s] }
      names      = parameters.map { |type, name| name }
      required   = parameters.map { |type, name| name if type.eql?(:req) }.compact

      # validate names
      unless (extra_keys = required - self.params.keys).empty?
        raise ArgumentError, "Following keys aren't available in params: #{extra_keys.inspect}\nAvailable keys: #{self.params.keys.inspect}"
      end

      args = Array.new
      parameters.each do |type, name|
        args.push(self.params[name]) if type.eql?(:req) || (type.eql?(:opt) && !self.params[name].nil?) # this is a bit complex, but we have to do because of rewriting optional args by nil value if we use just map with params[name]
      end
      puts "Rendering #{self.class}##{action} with #{args.map(&:inspect).join(", ")}"
      self.response.body = self.send(action, *args)
    end
  end
end
