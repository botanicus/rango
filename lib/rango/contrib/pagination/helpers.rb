# encoding: utf-8

module Rango
  module Pagination
    module PaginationMixin
      # @since 0.0.2
      def paginate(page = Page.current)
        root = File.dirname(__FILE__)
        template = File.join(root, "pagination")
        partial template, page: page
      end
    end
  end
end
