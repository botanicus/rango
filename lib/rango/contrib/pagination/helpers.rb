class Rango
  module Pagination
    module PaginationMixin
      # This is deprecated, because althought it works,
      # it isn't method of controller, and so it have not request object
      #attr_accessor :rango_paginate_root
      #def included(base)
      #  if base.respond_to?(:root)
      #    # rango-slices
      #    base.rango_paginate_root = base.root
      #  else
      #    base.rango_paginate_root = Rango.root
      #  end
      #end
      
      def rango_paginate_root
        controller = self.class
        constant = controller.superclass.to_s.split("::").first
        if constant.match(/Slice$/)
          Object::const_get(constant).root
        else
          Rango.root
        end
      end

      def rango_paginate_path
        "#{rango_paginate_root}/app/views/shared/pagination"
      end

      def paginate(page = Page.current)
        partial rango_paginate_path, :page => page, :request => request
      rescue Rango::ControllerExceptions::TemplateNotFound
        path = File.expand_path(File.join(File.dirname(__FILE__), "pagination"))
        partial path, :page => page, :request => request
      end
    end
  end
end