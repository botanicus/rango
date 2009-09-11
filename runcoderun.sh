#!/bin/sh

for libdir in vendor/*/lib
  do RUBYLIB="$libdir:$RUBYLIB"
done

exec spec1.9 --options spec/spec.opts spec
