# encoding: utf-8

require "rango/controller"
require_relative "models"

class Twitter < Rango::Controller
  # before :authenticate, except: [:login, :logout]

  def authenticate
    warden = request.env["warden"]
    warden.authenticate! unless warden.user
  end

  def login
    "Please log in."
  end

  def logout
    redirect "/", success: "You have been logged out"
  end

  def signup
    "<h1>Sign up</h1>"
  end

  def index
    render "index"
  end

  def timeline
    @posts = Post.all
    display @posts, "list.html"
  end

  def show(id)
    @post = Post.get(id)
    raise Error404.new(params) unless @post
    display @post, "show.html"
  end
end
