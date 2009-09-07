# encoding: utf-8

module Rango
  module ORM
    class Adapter
      def initialize
        Project.orm = self.class.name.split("::").last
      end

      def load
        raise NotImplementedError, "You have to implement Adapter#load method!"
      end

      def connect
        raise NotImplementedError, "You have to implement Adapter#connect method!"
      end

      def finish
        Rango.logger.info("Database connection established with #{Project.orm} and database #{path}")
      end

      protected
      def try_connect(&block)
        adapter  = Project.settings.database_adapter
        database = Project.settings.database_name
        block.call(adapter, database)
      rescue Exception => exception
        Rango.logger.exception(exception)
        Rango.logger.fatal("Database connection can't be established, exiting")
        exit 1
      end
    end
  end
end
