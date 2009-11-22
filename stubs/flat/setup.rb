# encoding: utf-8

# This hook will be executed in context of current generator object before templater start to generate new files.
# You can update context hash and register hooks. Don't forget to use merge! instead of merge, because you are
# manipulating with one object, rather than returning new one.

# rango create flat api
# rango create flat api.ru
hook do |generator, context|
  unless generator.target.end_with?(".ru")
    generator.target = "#{generator.target}.ru"
  end
end
