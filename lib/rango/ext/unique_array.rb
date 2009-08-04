# encoding: utf-8

# Get is using it
# co treba udelat to pres observery?
module Rango
  class UniqueArray < Array
    def push(*args)
      args.each do |arg|
        unless self.include?(arg)
          super(arg)
        end
      end
    end
    alias_method :<<, :push
  end
end
