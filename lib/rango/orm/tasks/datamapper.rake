# encoding: utf-8

namespace :db do
  # @since 0.0.2
  desc "Automigrate the database. It will destroy all the data!"
  task :automigrate, :environment, :needs => :environment do |task, args|
    RACK_ENV = args.environment || ENV["RACK_ENV"] || "development"
    Rango.logger.info("[#{Rango.environment}] Migrating databases ...")
    result = DataMapper.auto_migrate!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  # @since 0.0.2
  desc "Autoupgrade the database structure. Data should stay untouched."
  task :autupgrade, :environment, :needs => :environment do |task, args|
    RACK_ENV = args.environment || ENV["RACK_ENV"] || "development"
    Rango.logger.info("[#{Rango.environment}] Upgrading databases ...")
    result = DataMapper.auto_upgrade!
    Rango.logger.debug("Result: #{result.inspect}")
  end

  desc "Report count of objects in database"
  task :report, :environment, :needs => :environment do |task, args|
    RACK_ENV = args.environment || ENV["RACK_ENV"] || "development"
    ObjectSpace.classes.each do |klass|
      if klass.included(DataMapper::Resource)
        puts "#{model_class}: #{model_class.count}"
      end
    end
  end

  # @since 0.0.2
  desc "Run migrations"
  task :migrate, :environment, :needs => :environment do |task, args|
    RACK_ENV = args.environment || ENV["RACK_ENV"] || "development"
    abort "Use rake db:migrate:up[version] or db:migrate:down[version]"
  end

  namespace :migrate do
    task :load => :environment do
      begin
        require "dm-migrations/migration_runner"
      rescue LoadError
        abort "You have to install dm-migrations gem for this!"
      end
      FileList["db/migrations/*.rb"].each do |migration|
        load migration
      end
    end

    # rake db:migrate:up[version]
    # rake db:migrate:up[,environment]
    desc "Migrate up using migrations"
    task :up, :version, :environment, :needs => :load do |task, args|
      version = args.version || ENV['VERSION']
      raise ArgumentError, "You have to specify version!" if version.nil?
      migrate_up!(version)
    end

    desc "Migrate down using migrations"
    task :down, :version, :environment, :needs => :load do |task, args|
      version = args.version || ENV['VERSION']
      raise ArgumentError, "You have to specify version!" if version.nil?
      migrate_down!(version)
    end
  end
end
