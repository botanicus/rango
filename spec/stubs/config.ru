# encoding: utf-8

use Rack::ContentType
use Rack::ContentLength
run lambda { |env| [200, Hash.new, "Just a test!"] }
