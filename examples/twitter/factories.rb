# encoding: utf-8

require "rango"

Rango.boot

Project.import("models.rb")
Project.logger.debug("Migrating Database ...")

DataMapper.auto_migrate!

Project.logger.debug("Creating posts ...")
posts = [
  ["This is my first post!"],
  ["This is my second post!"],
  ["This is my third post!"]]
posts.each do |body|
  Post.create(body: body)
end
