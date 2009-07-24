# encoding: utf-8

require_relative "../helper"

Rango.boot

RBench.run(100) do
  column :times
  column :rango,   title: "Rango"
  column :ramaze,  title: "Ramaze"
  column :sinatra, title: "Sinatra"
  column :merb,    title: "Merb"
  column :rails,   title: "Rails"

  report "Basic request/response processing" do
  end

  summary "All requests"
end
