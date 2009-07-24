# encoding: utf-8

require "rubygems"

# dependencies
Rango.dependency "dm-core", :github => "datamapper/dm-core"
Rango.dependency "dm-validations", :github => "datamapper/dm-validations"
Rango.dependency "dm-aggregates", :github => "datamapper/dm-aggregates"
Rango.dependency "haml", :github => "nex3/haml"

if File.directory?("gems")
  Gem.path.clear
  Gem.path.push(Project.path.join("gems").to_s)
end

# database connection
DataMapper.setup(:default, "sqlite3://#{Project.root}/development.db")
