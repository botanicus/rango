# encoding: utf-8

module Rango
  module Pagination
    module Sequel
      module Dataset
        # @since 0.2.2
        # @example
        #   Sticker.paginate(page, 20, online: false)
        #   Sticker.filter(online: false).paginate(page)
        def paginate(current = 1, per_page = Page.per_page, options = nil)
          current = current ? current.to_i : 1 # current can be nil or "1"
          page = Page.new(current: current, count: self.count, per_page: per_page)
          dataset = options ? self.filter(options) : self
          return page, dataset.limit(per_page, (current - 1) * per_page)
        end
      end
    end
  end
end

Sequel::Dataset.send(:include, Rango::Pagination::Sequel::Dataset)
