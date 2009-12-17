#!/usr/bin/env ruby -i

# This is black magic!
# If you like Perl, you will probably enjoy it
# However it's easy to write and it works, so why not.

# == Normalize your source code == #
# 1) replace tabs by two space
# 2) remove trailing whitespace
# 3) add \n at the end of file unless it's already there

# == Usage == #
# ./normalize.rb app/controller/application_controller.rb
# cat app/controller/application_controller.rb | ./normalize.rb
#
# == Implementation == #
# The point is that ruby with -i will edit files
ARGF.each_line do |line|
  puts line.gsub(/\t/, "  ").rstrip
end
