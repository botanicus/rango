# encoding: utf-8

module Rango
  module MessageMixin
    # The rails-style flash messages
    # @since 0.0.2
    def message
      @message ||= (request.GET[:msg] || Hash.new)
    end
    
    # @since 0.0.2
    def redirect(url, options = Hash.new)
      self.status = 302

      # for example ?msg[error]=foo
      [:error, :success, :notice].each do |type|
        if msg = (options[type] || message[type])
          url.concat("?msg[#{type}]=#{msg}")
        end
      end

      self.headers["Location"] = URI.escape(url)
      return String.new
    end
  end
end
