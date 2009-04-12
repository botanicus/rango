#!/usr/bin/env ruby

argv = ARGV + %w[-a fcgi]
Rango.start(argv)