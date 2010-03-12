# encoding: utf-8

require "rango/gv"
require "rango/mini"
require "rango/mixins/render"

require "rango" # Rango.root

# NOTE: this is just proof of concept, do not use it so far!
# However this is the way how we can use CRUD in Rango.
module Rango
  module GV
    module Scaffolding
      extend Rango::RenderMixin
      def self.list(klass)
        Rango::Mini.app do |request, response|
          objects = klass.all
          render "scaffolding/list.html", objects: objects
        end
      end

      def self.show(klass)
        Rango::Mini.app do |request, response|
          object = klass.get(params[:id])
          render "scaffolding/show.html", object: object
        end
      end

      def self.new(klass)
        Rango::Mini.app do |request, response|
          render "scaffolding/new.html", object: klass.new
        end
      end

      def self.create(klass, show_url)
        Rango::Mini.app do |request, response|
          klass.create!(params[:post])
          response.redirect show_url
        end
      end

      def self.destroy(klass, list_url)
        Rango::Mini.app do |request, response|
          object = klass.get(params[:id])
          object.destroy
          response.redirect list_url
        end
      end
    end
  end
end
