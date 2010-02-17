# encoding: utf-8

require "sequel/extensions/pagination"

module Rango
  module Pagination
    module Sequel
      module Dataset
        # @since 0.2.2
        # @example Post.paginate(page, order: [:updated_at.desc])
        # @example Post.first.comments.paginate(page, order: [:updated_at.desc])
        def paginate(pagenum = 1, options = Hash.new)
          per_page = defined?(PER_PAGE) ? PER_PAGE : 10
          pagenum = 1 if pagenum.nil?
          super(pagenum, per_page)
          page = self.page(pagenum.to_i, options)
          Page.current = page
        end

        # @since 0.2.2
        def page(current)

          Page.new(current: current, count: self.count, per_page: per_page)
        end
      end
    end
  end
end

Sequel::Dataset.send(:include, Rango::Pagination::Sequel::Dataset)
