# coding=utf-8

# TODO: db:automigrate etc
# dm:automigrate must fail in production, but it will be overridable by --force option

require "rango/ext/thor"

class Db < RangoThor
  # @since 0.0.2
  desc "automigrate", "Automigrate the database. It will destroy all the data!"
  def automigrate
    Rango.logger.debug("Migrating database #{Project.settings.database_name} ...")
    result = DataMapper.auto_migrate!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  # @since 0.0.2
  desc "autoupgrade", "Autoupgrade the database structure. Data should stay untouched."
  def autoupgrade
    Rango.logger.debug("Upgrading database #{Project.settings.database_name} ...")
    result = DataMapper.auto_upgrade!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  # @since 0.0.2
  desc "migrate", "Run migrations."
  def migrate
  end
end