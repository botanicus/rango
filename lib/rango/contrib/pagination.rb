# encoding: utf-8

require "pathname" # TODO: it should be done in dm-aggregates # TODO 2: don't use this crappy shit at all!
#Rango.dependency("dm-aggregates")

Rango.import("contrib/pagination/page")
Rango.import("contrib/pagination/strategies")
Rango.import("contrib/pagination/helpers")
Rango.import("contrib/pagination/adapters/#{Project.settings.orm || "datamapper"}")

Rango.import("controller") # TODO: it should not works just with controller
Rango::Controller.send(:include, Rango::Pagination::PaginationMixin)
# require code that must be loaded before the application

# default route rule
# /products?page=5
Rango::Pagination::Strategies::Default.activate
