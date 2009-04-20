# coding: utf-8

require "erb"
require "extlib"

# TODO: documentation
# TODO: specs
class SettingsNotFound < StandardError
end

class TemplateNotFound < StandardError
  # @since 0.0.2
  attr_accessor :message

  # @since 0.0.2
  def initialize(template, locations)
    self.message = "Template '#{template}' wasn't found in any of these locations: #{locations.join(", ")}."
  end
end

# @since 0.0.1
class AnyStrategyMatched < StandardError
end

# @since 0.0.2
class SkipFilter < StandardError
end

# @since 0.0.2
class SkipRoute < StandardError
end

# superclass of all the controller exceptions
class Rango
  module HttpExceptions
    class HttpError < StandardError
      # @since 0.0.1
      attr_accessor :status, :params

      # @since 0.0.1
      def initialize(status, params = nil)
        self.status = status
        self.params = params
      end

      # @since 0.0.1
      def headers
        {'Content-Type' => 'text/html'}
      end

      # @since 0.0.1
      def render
        content = Rango.framework.path.join("../../templates/errors/#{self.status}.html.erb").read
        ERB.new(content).result(binding)
      end

      # @since 0.0.1
      def call(env)
        return [self.status, self.headers, self.body]
      end
    end

    class Error404 < HttpError
      # @since 0.0.1
      attr_accessor :params

      # @since 0.0.1
      def initialize(params = nil)
        super("404")
      end

      # @since 0.0.1
      def body
        @routes = Project.router.routes
        @router = Project.settings.router
        @path   = "TODO" # or maybe rack env ... THIS SHOULD BE IMPLEMENTED AS RACK MIDDLEWARE
        self.render
      end
    end

    class Error406 < HttpError
      # @since 0.0.1
      attr_accessor :params

      # @since 0.0.1
      def initialize(params)
        super("406")
      end

      # @since 0.0.1
      def body
        self.render
      end
    end

    class Error500 < HttpError
      # @since 0.0.1
      attr_accessor :exception, :params

      # @since 0.0.1
      def initialize(exception, params)
        super("500")
        self.exception = exception
        self.params = params
      end

      # @since 0.0.1
      def body
        self.render
        # ["<h1>#{exception.message}</h2>", '@exception.bactrace.join("<br />")']
      end
    end
  end
end


# stolen from merb

class Rango
  module HttpExceptions
    STATUS_CODES = {}
    class Base < StandardError #:doc:

      # === Returns
      # Integer:: The status-code of the error.
      #
      # @overridable
      # :api: plugin
      def status; self.class.status; end
      alias :to_i :status

      class << self

        # Get the actual status-code for an Exception class.
        #
        # As usual, this can come from a constant upwards in
        # the inheritance chain.
        #
        # ==== Returns
        # Fixnum:: The status code of this exception.
        #
        # :api: public
        def status
          const_get(:STATUS) rescue 0
        end
        alias :to_i :status

        # Set the actual status-code for an Exception class.
        #
        # If possible, set the STATUS constant, and update
        # any previously registered (inherited) status-code.
        #
        # ==== Parameters
        # num<~to_i>:: The status code
        #
        # ==== Returns
        # (Integer, nil):: The status set on this exception, or nil if a status was already set.
        #
        # :api: private
        def status=(num)
          unless self.status?
            register_status_code(self, num)
            self.const_set(:STATUS, num.to_i)
          end
        end

        # See if a status-code has been defined (on self explicitly).
        #
        # ==== Returns
        # Boolean:: Whether a status code has been set
        #
        # :api: private
        def status?
          self.const_defined?(:STATUS)
        end

        # Registers any subclasses with status codes for easy lookup by
        # set_status in Merb::Controller.
        #
        # Inheritance ensures this method gets inherited by any subclasses, so
        # it goes all the way down the chain of inheritance.
        #
        # ==== Parameters
        #
        # subclass<Merb::ControllerExceptions::Base>::
        #   The Exception class that is inheriting from Merb::ControllerExceptions::Base
        #
        # :api: public
        def inherited(subclass)
          # don't set the constant yet - any class methods will be called after self.inherited
          # unless self.status = ... is set explicitly, the status code will be inherited
          register_status_code(subclass, self.status) if self.status?
        end

        private

        # Register the status-code for an Exception class.
        #
        # ==== Parameters
        # num<~to_i>:: The status code
        #
        # :api: privaate
        def register_status_code(klass, code)
          name = self.to_s.split('::').last.snake_case
          STATUS_CODES[name.to_sym] = code.to_i
        end
      end
    end

    # informational
    class Informational               < Rango::HttpExceptions::Base; end
    class Continue                    < Rango::HttpExceptions::Informational; self.status = 100; end
    class SwitchingProtocols          < Rango::HttpExceptions::Informational; self.status = 101; end

    # successful
    class Successful                  < Rango::HttpExceptions::Base; end
    class OK                          < Rango::HttpExceptions::Successful; self.status = 200; end
    class Created                     < Rango::HttpExceptions::Successful; self.status = 201; end
    class Accepted                    < Rango::HttpExceptions::Successful; self.status = 202; end
    class NonAuthoritativeInformation < Rango::HttpExceptions::Successful; self.status = 203; end
    class NoContent                   < Rango::HttpExceptions::Successful; self.status = 204; end
    class ResetContent                < Rango::HttpExceptions::Successful; self.status = 205; end
    class PartialContent              < Rango::HttpExceptions::Successful; self.status = 206; end

    # redirection
    class Redirection                 < Rango::HttpExceptions::Base; end
    class MultipleChoices             < Rango::HttpExceptions::Redirection; self.status = 300; end
    class MovedPermanently            < Rango::HttpExceptions::Redirection; self.status = 301; end
    class MovedTemporarily            < Rango::HttpExceptions::Redirection; self.status = 302; end
    class SeeOther                    < Rango::HttpExceptions::Redirection; self.status = 303; end
    class NotModified                 < Rango::HttpExceptions::Redirection; self.status = 304; end
    class UseProxy                    < Rango::HttpExceptions::Redirection; self.status = 305; end
    class TemporaryRedirect           < Rango::HttpExceptions::Redirection; self.status = 307; end

    # client error
    class ClientError                 < Rango::HttpExceptions::Base; end
    class BadRequest                  < Rango::HttpExceptions::ClientError; self.status = 400; end
    class MultiPartParseError         < Rango::HttpExceptions::BadRequest; end
    class Unauthorized                < Rango::HttpExceptions::ClientError; self.status = 401; end
    class PaymentRequired             < Rango::HttpExceptions::ClientError; self.status = 402; end
    class Forbidden                   < Rango::HttpExceptions::ClientError; self.status = 403; end
    class NotFound                    < Rango::HttpExceptions::ClientError; self.status = 404; end
    class ActionNotFound              < Rango::HttpExceptions::NotFound; end
    class TemplateNotFound            < Rango::HttpExceptions::NotFound; end
    class LayoutNotFound              < Rango::HttpExceptions::NotFound; end
    class MethodNotAllowed            < Rango::HttpExceptions::ClientError; self.status = 405; end
    class NotAcceptable               < Rango::HttpExceptions::ClientError; self.status = 406; end
    class ProxyAuthenticationRequired < Rango::HttpExceptions::ClientError; self.status = 407; end
    class RequestTimeout              < Rango::HttpExceptions::ClientError; self.status = 408; end
    class Conflict                    < Rango::HttpExceptions::ClientError; self.status = 409; end
    class Gone                        < Rango::HttpExceptions::ClientError; self.status = 410; end
    class LengthRequired              < Rango::HttpExceptions::ClientError; self.status = 411; end
    class PreconditionFailed          < Rango::HttpExceptions::ClientError; self.status = 412; end
    class RequestEntityTooLarge       < Rango::HttpExceptions::ClientError; self.status = 413; end
    class RequestURITooLarge          < Rango::HttpExceptions::ClientError; self.status = 414; end
    class UnsupportedMediaType        < Rango::HttpExceptions::ClientError; self.status = 415; end
    class RequestRangeNotSatisfiable  < Rango::HttpExceptions::ClientError; self.status = 416; end
    class ExpectationFailed           < Rango::HttpExceptions::ClientError; self.status = 417; end

    # server error
    class ServerError                 < Rango::HttpExceptions::Base; end
    class InternalServerError         < Rango::HttpExceptions::ServerError; self.status = 500; end
    class NotImplemented              < Rango::HttpExceptions::ServerError; self.status = 501; end
    class BadGateway                  < Rango::HttpExceptions::ServerError; self.status = 502; end
    class ServiceUnavailable          < Rango::HttpExceptions::ServerError; self.status = 503; end
    class GatewayTimeout              < Rango::HttpExceptions::ServerError; self.status = 504; end
    class HTTPVersionNotSupported     < Rango::HttpExceptions::ServerError; self.status = 505; end
  end
end