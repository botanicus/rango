# encoding: utf-8

class HackerModel < FakeModel
  def foo
    '&"<>'
  end
end