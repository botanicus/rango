# coding: utf-8

begin
  adapter = Project.settings.database_adapter
  path = Project.settings.database_name
  DataMapper.setup(:default, "#{adapter}://#{Project.root}/#{path}")
  Rango.logger.debug("DataMapper started with database #{path}")
rescue
end
