# encoding: utf-8

require "rango/controller"
require "rango/mixins/crud"
require "rango/mixins/conventional_rendering"

module Rango
  class RESTController < Controller
    include CRUDMixin
    include ConventionalRendering
    def self.object_name=(object_name)
      @@object_name = object_name
    end

    def self.object_name
      @@object_name
    rescue NameError
      @@object_name = begin
        name = self.class.name
        name.split("::").last.snake_case
      end
    end

    # @api plugin
    def object_name
      self.class.object_name
    end

    def collection_name
      @@collection_name ||= @@object_name.to_s.pluralize
    end

    def self.named_route=(named_route)
      @@named_route = named_route
    end

    def self.named_route
      @@named_route
    rescue NameError
      @@named_route = begin
        name = self.class.name
        name.split("::").last.snake_case
      end
    end

    def named_route
      self.class.named_route
    end
  end
end
