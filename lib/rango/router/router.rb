# coding: utf-8

# TODO: includes
# TODO: documentation
# TODO: specs

Rango.import("router/strategies")
Rango.import("router/route")

class Rango
  class Router
    include Rango::HttpExceptions
    class << self
      # @since 0.0.1
      attribute :routers, Array.new

      # @since 0.0.1
      attribute :strategies, Array.new

      # @since 0.0.1
      def register(&block)
        router = self.new
        router.instance_eval(&block)
        routers.push(router)
        Project.router = router # FIXME
        return router
      end

      # @since 0.0.1
      def find(uri)
        routers.each do |router|
          router.find(uri)
        end
      end
    end

    attribute :routes, Array.new
    def initialize
      self.routes = Array.new
    end

    # match("kontakt/", method: "get")
    # Regexp#source returns the string representation
    # @since 0.0.1
    def match(pattern, params = Hash.new, &block)
      if pattern.is_a?(String)
        # match("/admin/objednavky/nove(/:page)")
        pattern.gsub!(/\((.+)\)/, '(\1)?')
        escaped = Regexp::quote(pattern)
        escaped.gsub!(%r[:([^/]+)], '(?<\1>[^/]+)')
        pattern = %r[^#{escaped}/?$]
      end
      route = Route.new
      route.match_pattern = pattern
      route.match_params = params
      @routes.push(route)
      return route
    end
    
    # TODO: this methods doesn't check the methods, see strategies.rb
    def get(pattern, params = Hash.new, &block)
      params[:method] = "get"
      match(pattern, params, &block)
    end
    
    def post(pattern, params = Hash.new, &block)
      params[:method] = "post"
      match(pattern, params, &block)
    end
    
    def put(pattern, params = Hash.new, &block)
      params[:method] = "put"
      match(pattern, params, &block)
    end
    
    def delete(pattern, params = Hash.new, &block)
      params[:method] = "delete"
      match(pattern, params, &block)
    end
    
    # resource :posts, admin_prefix: "/admin"
    # GET    /produkt/maslo
    # GET    /admin/produkt/new
    # GET    /admin/produkt/edit/maslo
    # PUT    /admin/produkt/maslo
    # POST   /admin/produkt
    # DELETE /admin/produkt/maslo
    # class Posts < Rango::Controller
    #   before :ensure_authenticated, except: ["get"]
    #   def get(slug)
    #     post = Post.get(slug)
    #     render "posts/get", post: post
    #   end
    # 
    #   def post(data)
    #     post = Post.new(data)
    #     if post.save
    #       redirect "/posts"
    #     else
    #       self.new
    #     end
    #   end
    # 
    #   def put(slug)
    #   end
    # 
    #   def delete(slug)
    #   end
    # end
    def resource(pattern, params = Hash.new, &block)
      # TODO
    end

    # @since 0.0.1
    def inspect
      @routes.inspect
    end

    # @since 0.0.1
    def find(uri)
      route = @routes.find { |route| route.match?(uri) }
      raise Error404.new unless route
      return route
    end
  end
end
