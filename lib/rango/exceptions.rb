# encoding: utf-8

SettingsNotFound = Class.new(StandardError)

class TemplateNotFound < StandardError
  # @since 0.0.2
  attr_accessor :message

  # @since 0.0.2
  def initialize(template, locations)
    self.message = "Template '#{template}' wasn't found in any of these locations: #{locations.join(", ")}."
  end
end

# @since 0.0.1
AnyStrategyMatched = Class.new(StandardError)

# @since 0.0.2
SkipFilter = Class.new(StandardError)

# superclass of all the controller exceptions
module Rango
  class HttpError < StandardError
    CONTENT_TYPE ||= "text/plain"

    attr_reader :content_type, :headers
    def initialize(*args)
      @headers = Hash.new
      super(*args)
    end

    def inspect
      self.to_response.inspect
    end

    # @returns [String]
    # @example NotFound.new.to_snakecase # "not_found"
    def to_snakecase
      self.class.name.snake_case
    end

    def status() self.class::STATUS end
    def content_type
      @content_type ||= self.class::CONTENT_TYPE
    end

    def to_response
      headers = {"Content-Type" => self.content_type}.merge(self.headers)
      [self.status, self.headers, [self.message]]
    end

    def self.const_missing(name)
      if [:STATUS, :CONTENT_TYPE].include?(name)
        raise "Every descent of HTTPError class has to have defined constant #{name}."
      else
        super(name)
      end
    end
  end

  # http://en.wikipedia.org/wiki/List_of_HTTP_status_codes

  # informational
  class Informational               < Rango::HttpError; end
  class Continue                    < Rango::Informational; STATUS ||= 100; end
  class SwitchingProtocols          < Rango::Informational; STATUS ||= 101; end

  # successful
  class Successful                  < Rango::HttpError; end
  class OK                          < Rango::Successful; STATUS ||= 200; end
  class Created                     < Rango::Successful; STATUS ||= 201; end
  class Accepted                    < Rango::Successful; STATUS ||= 202; end
  class NonAuthoritativeInformation < Rango::Successful; STATUS ||= 203; end
  class NoContent                   < Rango::Successful; STATUS ||= 204; end
  class ResetContent                < Rango::Successful; STATUS ||= 205; end
  class PartialContent              < Rango::Successful; STATUS ||= 206; end

  # redirection
  class Redirection                 < Rango::HttpError; end
  class MultipleChoices             < Rango::Redirection; STATUS ||= 300; end
  class MovedPermanently            < Rango::Redirection; STATUS ||= 301; end
  class MovedTemporarily            < Rango::Redirection; STATUS ||= 302; end
  class SeeOther                    < Rango::Redirection; STATUS ||= 303; end
  class NotModified                 < Rango::Redirection; STATUS ||= 304; end
  class UseProxy                    < Rango::Redirection; STATUS ||= 305; end
  class TemporaryRedirect           < Rango::Redirection; STATUS ||= 307; end

  # client error
  class ClientError                 < Rango::HttpError; end
  class BadRequest                  < Rango::ClientError; STATUS ||= 400; end
  class MultiPartParseError         < Rango::BadRequest; end
  class Unauthorized                < Rango::ClientError; STATUS ||= 401; end
  class PaymentRequired             < Rango::ClientError; STATUS ||= 402; end
  class Forbidden                   < Rango::ClientError; STATUS ||= 403; end
  class NotFound                    < Rango::ClientError; STATUS ||= 404; end
  class ActionNotFound              < Rango::NotFound; end
  class TemplateNotFound            < Rango::NotFound; end
  class LayoutNotFound              < Rango::NotFound; end
  class MethodNotAllowed            < Rango::ClientError; STATUS ||= 405; end
  class NotAcceptable               < Rango::ClientError; STATUS ||= 406; end
  class ProxyAuthenticationRequired < Rango::ClientError; STATUS ||= 407; end
  class RequestTimeout              < Rango::ClientError; STATUS ||= 408; end
  class Conflict                    < Rango::ClientError; STATUS ||= 409; end
  class Gone                        < Rango::ClientError; STATUS ||= 410; end
  class LengthRequired              < Rango::ClientError; STATUS ||= 411; end
  class PreconditionFailed          < Rango::ClientError; STATUS ||= 412; end
  class RequestEntityTooLarge       < Rango::ClientError; STATUS ||= 413; end
  class RequestURITooLarge          < Rango::ClientError; STATUS ||= 414; end
  class UnsupportedMediaType        < Rango::ClientError; STATUS ||= 415; end
  class RequestRangeNotSatisfiable  < Rango::ClientError; STATUS ||= 416; end
  class ExpectationFailed           < Rango::ClientError; STATUS ||= 417; end

  # server error
  class ServerError                 < Rango::HttpError; end
  class InternalServerError         < Rango::ServerError; STATUS ||= 500; end
  class NotImplemented              < Rango::ServerError; STATUS ||= 501; end
  class BadGateway                  < Rango::ServerError; STATUS ||= 502; end
  class ServiceUnavailable          < Rango::ServerError; STATUS ||= 503; end
  class GatewayTimeout              < Rango::ServerError; STATUS ||= 504; end
  class HTTPVersionNotSupported     < Rango::ServerError; STATUS ||= 505; end
end
