# encoding: utf-8

require "dm-aggregates"

module Rango
  module Pagination
    module DataMapper
      module Model
        # @since 0.2.2
        attr_accessor :page

        # @since 0.0.2
        # @example Post.paginate(page, order: [:updated_at.desc])
        # the count options are very important
        # Product.count vs. Product.count(online: true)
        def paginate(pagenum = 1, per_page = Page.per_page, options = Hash.new)
          pagenum = 1 if pagenum.nil?
          page = Page.new(current: current, count: self.count(options), per_page: per_page)
          offset = page.number(:db) * page.per_page
          dataset = self.all(options.merge!(offset: offset, limit: page.per_page))
          return page, dataset
        end
      end
    end
  end
end
