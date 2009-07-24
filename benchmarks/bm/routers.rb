# encoding: utf-8

require_relative "../helper"

RBench.run(100) do
  column :times
  column :urlmap,  title: "Rack::URLMap in Rango"
  column :rack,    title: "Rack router in Rango"
  column :merb,    title: "Merb router"
  column :rails,   title: "Rails router"
  column :sinatra, title: "Sinatra routing"

  group "A 1521 route set with routes nested evenly 2 levels deep" do
    report "Homepage" do
    end

    report "Request with params" do
    end
  end

  summary "foo"
end
