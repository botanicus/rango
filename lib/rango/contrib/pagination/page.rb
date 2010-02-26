# encoding: utf-8

class Page
  class << self
    # @since 0.0.2
    attr_accessor :route_hook

    # @since 0.2.2
    attr_writer :per_page
    def per_page
      @per_page ||= 10
    end

    # register_route_hook do ... end
    # OR
    # register_route_hook method(:foo)
    # @since 0.0.2
    def register_route_hook(callable = nil, &block)
      callable = (callable.nil? ? block : callable)
      self.route_hook = callable
    end

    def route(request, page, int)
      self.route_hook.call(request, page, int)
    end
  end

  # @since 0.0.2
  attr_accessor :number

  # @since 0.0.2
  attr_reader   :count, :per_page

  # Page.new(params[:page], count, per_page)
  #def initialize(current_page, count, per_page)
  # @since 0.0.2
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
  # @since 0.0.2
  def number(type = :human)
    case type
    when :human then @number
    # it can't be smaller than 0
    when :db    then @number == 0 ? 0 : @number - 1
    else raise ArgumentError
    end
  end

  # Count of pages
  # @since 0.0.2
  def max
    if @count % @per_page == 0
      @max ||= (@count / @per_page)
    else
      @max ||= (@count / @per_page) + 1
    end
  end

  # Current plus 1 or nil if it' the last page
  # @since 0.0.2
  def next
    if @number < max
      return Page.new(current: @number + 1, count: @count, per_page: @per_page)
    end
  end

  # Current minus 1 or nil if it' the first page
  # @since 0.0.2
  def previous
    if @number > 1
      return Page.new(current: @number - 1, count: @count, per_page: @per_page)
    end
  end

  # @since 0.0.2
  def last
    Page.new(current: max, count: @count, per_page: @per_page)
  end

  # @since 0.0.2
  def first
    Page.new(current: 1, count: @count, per_page: @per_page)
  end

  # @since 0.0.2
  def first?
    self.number == 1
  end

  # @since 0.0.2
  def last?
    self.number == max
  end
end
