# encoding: utf-8

Rango.dependency "dm-core", gem: true
require_relative "support"

begin
  adapter = Project.settings.database_adapter
  path = Project.settings.database_name
  DataMapper.setup(:default, "#{adapter}://#{Project.root}/#{path}")
rescue Exception => exception
  Rango.logger.exception(exception)
  Rango.logger.fatal("Database connection can't be established, exiting")
  exit 1
end

Rango.logger.info("DataMapper started with database #{path}")