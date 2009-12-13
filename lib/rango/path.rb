# encoding: utf-8

require "rango"

begin
  require "media-path"
rescue LoadError
  raise LoadError, "You have to install media-path gem!"
end

# @since 0.0.2
# @example
#   Rango.path
#   # => /usr/lib/ruby/lib/ruby/site_ruby/1.8/rango
# @return [Path] Rango root path
def Rango.path
  @path ||= MediaPath.new(self.root)
end
