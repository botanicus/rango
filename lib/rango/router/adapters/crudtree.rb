require "crudtree/generator"
require_relative "usher"

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
