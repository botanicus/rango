# coding=utf-8

class Rango::Handler
  # @since 0.0.1
  # @return [String] HTTP status.
  attr_accessor :status
  
  # @since 0.0.1
  # @return [Hash[String => String]] HTTP headers.
  attr_accessor :headers
  
  # @since 0.0.1
  # @return [#each] Body of the response. Probably HTML.
  attr_writer :body
  
  # @since 0.0.1
  # @example
  #   Rango::Handler.new(302)
  # @param [#to_s, *default=200] status HTTP status.
  # @return [type] explanation
  def initialize(status = "200")
    @status = status.to_s
    @headers = {'Content-Type' => 'text/html'}
    @body = ["<h1>TODO</h1>", "<p>Rewrite in subclasses.</p>"]
  end
  
  # @since 0.0.1
  # @return [#each] Response body responding to +#each+. If +@body+ is +String+, then +#body+ will be +[String]+.
  def body
    if not @body.respond_to?(:each)
      @body = [@body]
    elsif @body.nil?
      @body = String.new if @body.nil?
    end
    return @body
  end
  
  # @since 0.0.1
  # @return [Hash["Content-Length": String<length>]] Returns
  # @future This will return just the +length+.
  def content_length
    lengths = self.body.map { |line| line.to_s.size }
    length  = lengths.inject { |sum, item| sum + item }
    return {'Content-Length' => length.to_s}
  end

  # @since 0.0.1
  # @param [Hash] env Rack request environment.
  # @return [Array[String:status], Hash:headers[String => String], #each:body] This array will be returned to Rack.
  def call(env)
    headers = self.headers.merge(content_length)
    return [self.status, headers, self.body]
  rescue Exception => exception
    Project.logger.exception(exception)
    @body = ["<h1>#{exception.message}</h1>"]
    exception.backtrace.each do |trace|
      @body.push("<li>#{trace}</li>")
    end
    return ["500", headers, self.body]
  end
end