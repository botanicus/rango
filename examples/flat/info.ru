#!/usr/bin/env rackup -p 4000 -s thin
# encoding: utf-8

require "rango"
require "rango/mixins/mini"

Rango.boot

use Rango::Middlewares::Basic

map("/") do
  run app { |request, response|
    path_regexp  = Regexp.new(Regexp.quote(Rango.path.parent.to_s + "/"))
    loaded_files = $LOADED_FEATURES.grep(path_regexp)
    @rango_files = loaded_files.map { |file| file.sub(path_regexp, "") }.sort
    render "info"
  }
end
