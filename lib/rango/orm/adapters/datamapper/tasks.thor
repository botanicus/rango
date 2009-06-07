# encoding: utf-8

require "rango/ext/thor"

class Db < Rango::Tasks
  def initialize(*args)
    self.boot
    super(*args)
  end

  # @since 0.0.2
  desc "automigrate", "Automigrate the database. It will destroy all the data!"
  def automigrate
    unless Rango.debug && @opts[:force]
      abort "You are in production environment. This operation will destroy all your data. If you are sure what you are doing, use thor db:automigrate --force"
    end
    Rango.logger.info("Migrating database #{Project.settings.database_name} ...")
    result = DataMapper.auto_migrate!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  # @since 0.0.2
  desc "autoupgrade", "Autoupgrade the database structure. Data should stay untouched."
  def autoupgrade
    Rango.logger.info("Upgrading database #{Project.settings.database_name} ...")
    result = DataMapper.auto_upgrade!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  # @since 0.0.2
  desc "migrate", "Run migrations."
  def migrate
  end

  desc "report", "Report count of objects in database"
  def report
    Rango::ORM::DataMapper.models.each do |model_class|
      puts "#{model_class}: #{model_class.count}"
    end
  end
end
