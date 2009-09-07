# encoding: utf-8

class Module
  # No more Module.send(:include, Mixin)
  public :include
end
