# encoding: utf-8

# GV = generic views
require "rango/mixins/render"

# what about filters?
#   - include to controller or use directly (include Rango::GV, but what if I want to include just for example static gv?)
#   - or Rango::GV.extend FiltersMixin

module Rango
  module GV
    class View
      include Rango::Helpers
      include Rango::RenderMixin
      attr_reader :name, :definition
      attr_accessor :args, :custom_block # we can't use just block because of block(:head)
      attr_accessor :env, :request, :response
      def initialize(name, &definition)
        @name, @definition = name, definition
      end
      
      def setup(*args, &custom_block)
        self.args = args
        self.custom_block = custom_block
      end
      
      def call(env)
        Rango::Router.new.set_rack_env(env) # so env["usher.params"] => env["rango.router.params"]
        self.request = Rango::Request.new(env)
        self.response = Rack::Response.new
        self.env = env

        # Welcome to Ruby 1.9 world! instance_exec is the same as instance_eval,
        # but it can takes arguments for the custom_block
        args = [*self.args, self.custom_block]
        Rango.logger.debug("Calling generic view #{self.name} with #{args.inspect}")
        body = self.instance_exec(*args, &self.definition)

        # TODO: check how rack test if object is stringable, probably not this way
        raise ArgumentError unless body.respond_to?(:each) || body.is_a?(String)
        response.write(body)
        response.finish
      end
    end

    def self.define(action, &definition)
      # instance method for including
      define_method(action, &definition)

      # class method for direct usage
      # TODO: clean this mess before someone start vomit
      @@view = View.new(action, &definition)
      module_eval <<-RUBY, __FILE__, __LINE__
      def self.#{action}(*args, &block)
        view = @@view.dup
        view.setup(*args, &block)
        view # has #call
      end
      RUBY
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

# THE MAIN PROBLEM IS THIS CAN'T WORK WITH BLOCKS
# BECAUSE OF instance_exec(*args, &block, &definition) will cause syntax error in Ruby

###############
# This might be the best solution:
#Rango::GV.define(:static) do |view, template = nil, &block|
#end

# implementation: just definition.call(self, *self.args, &self.block)
###############
  
Rango::GV.define(:static) do |hook = nil|
  require "rango/helpers" # for javascripts etc helpers
  path = env["rango.router.params"][:template]
  path = hook.call(path) unless hook.nil?
  Rango.logger.debug("Rendering '#{path}'")
  render path
end
