# encoding: utf-8

module CRUDMixin
  def index(&block)
    raise ArgumentError, "You have to provide a block" if block.nil?
    set_context_value(collection_name, block.call)
    autorender
  end

  def show(&block)
    raise ArgumentError, "You have to provide a block" if block.nil?
    set_context_value(collection_name, block.call)
    autorender
  end

  def new(&block)
    raise ArgumentError, "You have to provide a block" if block.nil?
    set_context_value(collection_name, block.call)
    autorender
  end

  def edit(&block)
    raise ArgumentError, "You have to provide a block" if block.nil?
    set_context_value(collection_name, block.call)
    autorender
  end

  def create(notice = "Created successfully", error = "Can't create", &block)
    raise ArgumentError, "You have to provide a block" if block.nil?
    object = block.call
    if object.save
      message[:notice] = notice
      redirect url(named_route, object)
    else
      message[:error] = error
      render_relative "show"
    end
  end

  def update(notice = "Updated successfully", error = "Can't update", &block)
    raise ArgumentError, "You have to provide a block" if block.nil?
    object = block.call
    if object.save
      message[:notice] = notice
      redirect url(named_route, object)
    else
      message[:error] = error
      render_relative "show"
    end
  end
end
