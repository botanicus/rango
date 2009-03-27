class Rango::Handler
  attr_accessor :status, :headers, :body
  def initialize(status = "200")
    @status = status.to_s
    @headers = {'Content-Type' => 'text/html'}
    @body = ["<h1>TODO</h1>", "<p>Rewrite in subclasses.</p>"]
  end
  
  def body
    unless @body.respond_to?(:each)
      @body = [@body]
    end
    @body = String.new if @body.nil?
    return @body
  end
  
  def content_length
    lengths = self.body.map { |line| line.length }
    length  = lengths.inject { |sum, item| sum + item }
    {'Content-Length' => length.to_s}
  end
  
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