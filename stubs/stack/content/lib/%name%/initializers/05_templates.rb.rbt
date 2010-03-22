# encoding: utf-8

require "haml"
# require "pupu/adapters/rango"
require "helpers/adapters/rango"

# Haml setup
Rango.after_boot(:tilt) do
  Tilt::HamlTemplate.options[:format] = :html5
end

# FIXME: WTF, such a mess!
# Rango.media_root = Pupu.media_root = MediaPath.media_root = "public" # TODO: Rango should do it!
