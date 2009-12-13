# encoding: utf-8

namespace :db do
  desc "Perform migration using migrations in schema/migrations"
  task :migrate, :version, :environment, :needs => :environment do |task, args|
    require "sequel/extensions/migration"
    version = args.version || (ENV["VERSION"].to_i unless ENV["VERSION"].nil?) || nil
    Sequel::Migrator.apply(Sequel::Model.db, "db/migrations", version)
  end

  desc "Drop all tables"
  task :drop_tables => :sequel_env do
    Sequel::Model.db.drop_table *Sequel::Model.db.tables
  end

  desc "Drop all tables and perform migrations"
  task :reset => [:sequel_env, :drop_tables, :migrate]

  desc "Truncate all tables in database"
  task :truncate => :sequel_env do
    Sequel::Model.db << "TRUNCATE #{db.tables.join(', ')} CASCADE;"
  end
end
