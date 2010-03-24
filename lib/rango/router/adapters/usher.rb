# encoding: utf-8

begin
  require "usher"
rescue LoadError
  raise LoadError, "You have to install usher gem!"
end

Rango::Router.implement(:usher) do |env|
  # when usher routes to the default app, then usher.params is nil
  env["rango.router.params"] = env["usher.params"] || Hash.new # TODO: nil
end

module Rango
  module UrlHelper
    # url(:login)
    def url(*args)
      generator  = Rango::Router.app.router.generator
      route_name = args.shift
      route = generator.usher.named_routes[route_name]
      raise "No route found" if route.nil? # TODO: add RouteNotFound to usher and use it here as well
      if args.empty?
        generator.generate(route_name) # TODO: usher should probably have path.to_url
      else
        alts = route.paths.map(&:dynamic_keys) # one route can have multiple paths as /:id or /:id.:format
        keys = alts.first
        # FIXME: take a look at other alts as well !!!!
        # keys = alts.find.with_index { |item, index|  }

        # TODO: optional args
        keys_generator = keys.each
        args_generator = args.each
        opts = Hash.new

        keys.length.times do |index|
          key = keys_generator.next
          arg = args_generator.next
          if arg.respond_to?(key) # post instance
            opts[key] = arg.send(key)
          else # it's already a slug
            opts[key] = arg
          end
        end

        generator.generate(route_name, opts)
      end
    end
  end
end


# route = Rango::Router.app.router.generator.usher.named_routes[:admin_edit_sticker]
# p route.paths.map(&:dynamic_keys)
