# encoding: utf-8

module Rango
  module Settings
    class Erubis < Settings
      # @since 0.0.2
      hattribute :pattern, "<% %>" # can be string or regexp

      # @since 0.0.2
      hattribute :custom_class # use your own class instead of Erubis::Eruby. Don't forget that you must include (TODO: what) for autoescaping
    end
  end
end
