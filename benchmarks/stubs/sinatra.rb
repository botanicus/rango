# encoding: utf-8

class BenchmarkApp < Sinatra::Mocked
  get "/success" do
    "Hello World"
  end

  get "/:foo/:bar" do
    "Hello World"
  end
end
