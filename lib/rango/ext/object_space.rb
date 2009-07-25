# encoding: utf-8

module ObjectSpace
  # Returns all classes existing in runtime
  #
  # @author Botanicus
  # @since 0.0.3
  # @return [Array<Class>] List of all classes loaded into runtime
  def self.classes
    Array.new.tap do |objects|
      self.each_object(Class) do |object|
        objects << object
      end
    end
  end
end
