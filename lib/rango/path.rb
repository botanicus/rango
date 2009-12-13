# encoding: utf-8

require "rango"
require_gem "media-path"

# @since 0.0.2
# @example
#   Rango.path
#   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
# @return [Path] Rango root path
def Rango.path
  @path ||= MediaPath.new(self.root)
end
