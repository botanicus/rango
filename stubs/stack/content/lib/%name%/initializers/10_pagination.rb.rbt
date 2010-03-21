# encoding: utf-8

require "rango/contrib/pagination"

Rango.after_boot(:pagination) do
  Rango::Controller.send(:include, Rango::Pagination::PaginationMixin) # TODO: this shouldn't be necessary
  Rango::Pagination::Strategies::PageNumberOnTheEndOfRouteExcludeFirstPage.activate
end
