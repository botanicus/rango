# encoding: utf-8

# This hook will run before simple-templater creates new files from templates
# You can update context hash. Don't forget to use merge! instead of merge,
# because you are manipulating with one object, rather than returning new one
# Dir.pwd => empty directory where the project will be located

# rango create app blog --models=post,tag --controllers=posts,tags
hook do |generator, context|
  models  = context[:models] || Array.new
  controllers = context[:controllers] || Array.new
  context.merge!(models: models, controllers: controllers)
end
