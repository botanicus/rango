class RangoThor < Thor
  # def initialize
  #   require "rango"
  #   Rango.boot
  # end

  # @since 0.0.2
  desc "automigrate", "Automigrate the database. It will destroy all the data!"
  def automigrate
    DataMapper.auto_migrate!
  end

  # @since 0.0.2
  desc "autoupgrade", "Autoupgrade the database structure. Data should stay untouched."
  def autoupgrade
    DataMapper.auto_upgrade!
  end

  # @since 0.0.2
  desc "migrate", "Run migrations."
  def migrate
  end
end