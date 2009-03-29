# coding=utf-8

# TODO: db:automigrate etc
# dm:automigrate must fail in production, but it will be overridable by --force option
class Db < Thor
  desc "automigrate", "Automigrate the database. It will destroy all the data!"
  def automigrate
    DataMapper.auto_migrate!
  end
  
  desc "autoupgrade", "Autoupgrade the database structure. Data should stay untouched."
  def autoupgrade
    DataMapper.auto_upgrade!
  end
  
  desc "migrate", "Run migrations."
  def migrate
  end
end