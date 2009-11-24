# encoding: utf-8

# FIXME: this code is already in another file
# FIXME: DataMapper vs. Datamapper
module Rango
  class ORM
    class DataMapper
      class << self
        def models
          ObjectSpace.classes.map do |klass|
            klass.included(DataMapper::Resource)
          end
        end
      end
    end
  end
end
