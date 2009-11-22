# encoding: utf-8

require "dm-aggregates"

require "rango/contrib/pagination/page"
require "rango/contrib/pagination/strategies"
require "rango/contrib/pagination/helpers"
require "rango/contrib/pagination/adapters/#{Project.settings.orm || "datamapper"}"

require "rango/controller" # TODO: it should not works just with controller
Rango::Controller.send(:include, Rango::Pagination::PaginationMixin)
# require code that must be loaded before the application

# default route rule
# /products?page=5
Rango::Pagination::Strategies::Default.activate
