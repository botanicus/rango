# encoding: utf-8

# Generic Views
# Use directly or include into a controller if you want to use filters or customize them
# http://wiki.github.com/botanicus/rango/generic-views

require "rango/mini"
require "rango/router"
require "rango/mixins/render"
require "rubyexts/string" # String#camel_case
require "rubyexts/module" # Module#mattr_accessor

module Rango
  module GV
    def self.define(action, &block)
      const_name = action.to_s.camel_case
      
      if self.const_defined?(const_name)
        constant = self.const_get(const_name)
      else
        mixin = Module.new
        self.const_set(const_name, mixin)
        constant = const_get(const_name)
      end

      constant.module_eval <<-RUBY, __FILE__, __LINE__
        include Rango::RenderMixin
        extend  Rango::RenderMixin
        mattr_accessor :block

        # method Rango::GV::Static.static
        def self.#{action}(*args, &hook)
          #.call(env)? what it should returns? array or lambda?
          Rango::Mini.app do |request, response|
            if hook
              self.block.call(request, response, *args) do
                hook.call(request, response)
              end
            else
              self.block.call(request, response, *args)
            end
          end
        end

        # method Rango::GV::Static#static for inheritance
        def #{action}(*args, &hook)
          raise "Object #{self.inspect} must have request method defined!"  unless self.respond_to?(:request)
          raise "Object #{self.inspect} must have response method defined!" unless self.respond_to?(:response)
          if hook
            #{const_name}.block.call(request, response, *args) do
              hook.call(request, response)
            end
          else
            #{const_name}.block.call(request, response, *args) # returns body
          end
        end
      RUBY

      constant.block = block

      # method Rango::GV.static for direct usage in router
      define_singleton_method(action) do |*args, &hook|
        if hook
          constant.send(action, *args) do |request, response|
            Rango::Router.new.set_rack_env(request.env) # so env["usher.params"] => env["rango.router.params"]
            Rango.logger.debug("Calling generic view #{action} with #{args.inspect}")
            hook.call
          end
        else
          constant.send(action, *args)
        end
      end
    end
  end
end

# require params[:path]
# @example
#   Usher::Interface.for(:rack) do
#     get("/").to(Rango::GV.static("index"))
#     get("/:template").to(::Static.dispatcher(:show)).name(:static)
#     get("/:template").to(Rango::GenericViews.dispatcher(:static)).name(:static)
#     get("/:template").to do |env|
#       env["rango.params"][:template] # transform
#       Rango::GV.static
#     end
#   end

# Rango::GV.static("index")
# Rango::GV.static { |template| raise if template.eql?("base") }
Rango::GV.define(:static) do |template, &hook|
  require "rango/helpers" # for javascripts etc helpers
  path = template || env["rango.router.params"][:template]
  hook.call(path) unless hook.nil?
  Rango.logger.debug("Rendering '#{path}'")
  render path
end
