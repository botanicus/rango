# encoding: utf-8

module Rango
  module Pagination
    module Sequel
      module Dataset
        # @since 0.2.2
        def paginate(current = 1, per_page = Page.per_page, options = Hash.new)
          current = 1 if current.nil?
          page = Page.new(current: current, count: self.count, per_page: per_page)
          return page, limit(per_page, (current - 1) * per_page)
        end
      end
    end
  end
end

Sequel::Dataset.send(:include, Rango::Pagination::Sequel::Dataset)
