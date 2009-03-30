# coding=utf-8
Rango.import("contrib/pagination/page")

class Rango
  module Pagination
    class Strategy
      def self.activate
        Page.register_route_hook(self.new.method(:hook))
        #Page.register_route_hook do |request, page|
        #  self.new.hook(request, page)
        #end
      end
    end

    module Strategies
      class Default < Rango::Pagination::Strategy
        def hook(request, page)
          return "?page=#{page}"
        end
      end

      class PageNumberOnTheEndOfRoute < Rango::Pagination::Strategy
        def hook(request, page)
          # /products/1
          return File.join(File.split(request.full_uri)[0..-2].push(page.to_s))
        end
      end

      class PageNumberOnTheEndOfRouteExcludeFirstPage < Rango::Pagination::Strategy
        def hook(request, page)
          if page.eql?(1)
            # /products
            return File.join(File.split(request.full_uri)[0..-2])
          else
            # /products/2
            return PageNumberOnTheEndOfRoute.new.hook(request, page)
          end
        end
      end
    end
  end
end
