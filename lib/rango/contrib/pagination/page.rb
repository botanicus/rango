class Page
  class << self
    attr_writer :current
    attr_accessor :route_hook
    def current
      Rango.logger.debug("Page initialized: #{@current.inspect}")
      return @current
    end
    # Page.current = page # implicitly in datamapper.rb
    # paginate Page.current

    # register_route_hook do ... end
    # OR
    # register_route_hook method(:foo)
    def register_route_hook(callable = nil, &block)
      callable = (callable.nil? ? block : callable)
      self.route_hook = block
    end

    def route(request, int)
      self.route_hook.call(request, int)
    end
  end

  attr_accessor :number
  attr_reader   :count, :per_page
  # Page.new(params[:page], count, per_page)
  #def initialize(current_page, count, per_page)
  def initialize(params)
    raise ArgumentError unless params.is_a?(Hash)
    @count = params[:count].to_i || raise(ArgumentError, "params[:count] must be given")
    @per_page = (params[:per_page] or 10).to_i
    # can be nil
    @number  = (params[:current].nil? ? 1 : params[:current].to_i)
    @number  = 1   if @number < 1
    @number  = max if @number > max
  end

  # NOTE: offset start as normal array from 0, but page from 1!
  def number(type = :human)
    case type
    when :human then @number
    # it can't be smaller than 0
    when :db    then @number == 0 ? 0 : @number - 1
    else raise ArgumentError
    end
  end

  # Count of pages
  def max
    if @count % @per_page == 0
      @max ||= (@count / @per_page)
    else
      @max ||= (@count / @per_page) + 1
    end
  end

  # Current plus 1 or nil if it' the last page
  def next
    if @number < max
      return Page.new(:current => @number + 1, :count => @count, :per_page => @per_page)
    end
  end

  # Current minus 1 or nil if it' the first page
  def previous
    if @number > 1
      return Page.new(:current => @number - 1, :count => @count, :per_page => @per_page)
    end
  end

  def last
    Page.new(:current => max, :count => @count, :per_page => @per_page)
  end

  def first
    Page.new(:current => 1, :count => @count, :per_page => @per_page)
  end

  def first?
    self.number == 1
  end

  def last?
    self.number == max
  end
end
