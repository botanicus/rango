# encoding: utf-8

module Rango
  module Pagination
    module PaginationMixin
      # @since 0.0.2
      def paginate(page)
        root = File.dirname(__FILE__)
        template = File.join(root, "pagination")
        partial template, page: page
      end

      # @since 0.0.7
      def previous_page(text, page)
        link_to text, Page.route(request, page, page.previous.number)
      end

      # @since 0.0.7
      def next_page(text, page)
        link_to text, Page.route(request, page, page.next.number)
      end
    end
  end
end
