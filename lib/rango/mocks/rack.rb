# encoding: utf-8

class Rango
  module Mocks
    def mock_env(params = Hash.new)
      {
        "rack.version"      => [1, 0],
        "rack.input"        => StringIO.new,
        "rack.errors"       => StringIO.new,
        "rack.multithread"  => true,
        "rack.multiprocess" => true,
        "rack.run_once"     => false,
      }.merge(params)
    end
    
    def mock_request(params = Hash.new)
      Rango::Request.new(self.mock_env(params))
    end
  end
end
