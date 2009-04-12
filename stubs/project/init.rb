# coding=utf-8

# dependencies
Rango.dependency "dm-core", github: "datamapper/dm-core"
Rango.dependency "haml", github: "nex3/haml"

if Dir.exist?("gems")
  Gem.path.clear
  Gem.path.push(Project.path.join("gems").to_s)
end

# database connection
# DataMapper.setup(:default, "sqlite3::memory")