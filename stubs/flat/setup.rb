# encoding: utf-8

# This hook will run before simple-templater creates new files from templates
# You can update context hash. Don't forget to use merge! instead of merge,
# because you are manipulating with one object, rather than returning new one
# Dir.pwd => empty directory where the project will be located

hook do |generator, context|
  generator.target = "#{generator.target}.ru"
end
