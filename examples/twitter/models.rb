# encoding: utf-8

class User
  include DataMapper::Resource
  property :login, String, key: true
  property :body, Text, length: (0..140)
end

class Post
  include DataMapper::Resource
  property :id, Serial
  property :body, Text, length: (0..140)
end
