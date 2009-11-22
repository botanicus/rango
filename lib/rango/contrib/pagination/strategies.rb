# encoding: utf-8
require "rango/contrib/pagination/page"

module Rango
  module Pagination
    class Strategy
      # @since 0.0.2
      def self.activate
        Page.register_route_hook(self.new.method(:hook))
        #Page.register_route_hook do |request, page|
        #  self.new.hook(request, page)
        #end
      end
    end

    module Strategies
      class Default < Rango::Pagination::Strategy
        # @since 0.0.2
        def hook(request, from, page)
          return "?page=#{page}"
        end
      end

      class PageNumberOnTheEndOfRoute < Rango::Pagination::Strategy
        # @since 0.0.2
        def hook(request, from, page)
          # /products/1
          return File.join(File.split(request.url)[0..-2].push(page.to_s))
        end
      end

      class PageNumberOnTheEndOfRouteExcludeFirstPage < Rango::Pagination::Strategy
        # Here is terrible important the from parameter
        # @since 0.0.2
        def hook(request, from, page)
          if from.number.eql?(1)
            # /products
            File.join(request.url, page.to_s)
          elsif page.eql?(1) && ! from.number.eql?(1)
            File.join((request.url)[0..-2]).chomp("/")
          else
            # /products/2
            return PageNumberOnTheEndOfRoute.new.hook(request, from, page)
          end
        end
      end
    end
  end
end
