# encoding: utf-8

module ObjectSpace
  def self.classes
    classes = Array.new
    ObjectSpace.each_object(Class) do |klass|
      classes << klass
    end
    return classes
  end
end