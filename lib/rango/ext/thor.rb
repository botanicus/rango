class RangoThor < Thor
  # def initialize
  #   require "rango"
  #   Rango.boot
  # end

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