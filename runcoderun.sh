#!/bin/sh

for libdir in vendor/*/lib
  do RUBYLIB="$libdir:$RUBYLIB"
done

if [[ "$#" = "0" ]] ; then
  exec spec --options spec/spec.opts spec
else
  exec spec --options spec/spec.opts $*
fi
