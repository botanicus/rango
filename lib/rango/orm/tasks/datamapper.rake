# encoding: utf-8

namespace :db do
  # @since 0.0.2
  desc "Automigrate the database. It will destroy all the data!"
  task :automigrate, :environment do |task, args|
    RANGO_ENV = args.environment || ENV["RANGO_ENV"] || "development"
    Rake::Task[:environment].invoke
    Rango.logger.info("[#{Rango.environment}] Migrating databases ...")
    result = DataMapper.auto_migrate!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  # @since 0.0.2
  desc "Autoupgrade the database structure. Data should stay untouched."
  task :autupgrade, :environment do |task, args|
    RANGO_ENV = args.environment || ENV["RANGO_ENV"] || "development"
    Rake::Task[:environment].invoke
    Rango.logger.info("[#{Rango.environment}] Upgrading databases ...")
    result = DataMapper.auto_upgrade!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  # @since 0.0.2
  desc "Run migrations"
  task :migrate, :environment do |task, args|
    RANGO_ENV = args.environment || ENV["RANGO_ENV"] || "development"
    Rake::Task[:environment].invoke
    abort "This task isn't implemented so far! You might want to use db:automigrate or db:autoupgrade instead."
  end

  desc "Report count of objects in database"
  task :report, :environment do |task, args|
    RANGO_ENV = args.environment || ENV["RANGO_ENV"] || "development"
    Rake::Task[:environment].invoke
    require "rango/orm/adapters/datamapper" # should be loaded in runtime, but isn't at the moment
    Rango::ORM::Datamapper.models.each do |model_class|
      puts "#{model_class}: #{model_class.count}"
    end
  end
end
