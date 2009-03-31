class Rango
  module Pagination
    module PaginationMixin
      # @since 0.0.2
      def paginate(page = Page.current)
        Project.settings.template_dirs.push(File.dirname(__FILE__)) # TODO: is it good solution?
        partial "pagination", page: page
      end
    end
  end
end