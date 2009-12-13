# encoding: utf-8

# http://wiki.github.com/botanicus/rango/pagination
# Don't forget to load your ORM adapter!
require "rango/contrib/pagination/page"
require "rango/contrib/pagination/strategies"
require "rango/contrib/pagination/helpers"

Rango::Helpers.send(:include, Rango::Pagination::PaginationMixin)
# require code that must be loaded before the application

# default route rule
# /products?page=5
Rango::Pagination::Strategies::Default.activate
