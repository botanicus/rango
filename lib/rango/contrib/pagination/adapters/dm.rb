module DataMapper
  module Resource
    module ClassMethods
      def paginate(pagenum = 1, options = Hash.new)
        pagenum = 1 if pagenum.nil?
        page = self.page(pagenum.to_i, options)
        Page.current = page
        offset = page.number(:db) * page.per_page
        self.all(offset: offset, limit: page.per_page, order: [:updated_at.desc]).all(options)
      end

      def page(current, options = Hash.new)
        per_page = defined?(PER_PAGE) ? PER_PAGE : 10
        # the count options are very important
        # Product.count vs. Product.count(online: true)
        Page.new(current: current, count: self.count(options), per_page: per_page)
      end
    end
  end
end
