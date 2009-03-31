class Rango
  module Pagination
    module PaginationMixin
      def paginate(page = Page.current)
        Project.settings.template_dirs.push(File.dirname(__FILE__)) # TODO: is it good solution?
        partial "pagination", :page => page
      end
    end
  end
end