# encoding: utf-8

require_relative "usher"

begin
  require "crudtree/generator"
rescue LoadError
  raise LoadError, "You have to install crudtree gem!"
end

module Rango
  module UrlHelper
    # resource(@post, :edit), resource(:posts)
    def resource(*args)
      crudtree_generator.generate(*args)
    end

    def crudtree_generator
      @@generator ||= CRUDtree::Generator.new(Rango::Router.app.master)
    end
  end
end
