#!/bin/sh

for libdir in vendor/*/lib
  do RUBYLIB="$libdir:$RUBYLIB"
done

exec spec --options spec/spec.opts spec
