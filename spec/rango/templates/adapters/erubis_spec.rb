# encoding: utf-8

require_relative "template_helpers"
require "rango/templates/adapters/erubis"

describe Rango::Templates::ErubisAdapter do
  include TemplateHelpers
  before(:each) do
    @engine = Rango::Templates::ErubisAdapter.new
    @template = template("basic.html.erb")
    Project.settings = settings(erubis: {pattern: "<% %>", custom_class: nil})
  end

  describe "#render" do
    it "should render template" do
      body = @engine.render(@template)
      body.should match("<h1>")
      body.should match("3#")
    end

    it "should work with context" do
      template = template("context.html.erb")
      body = @engine.render(template, who: "Rango")
      body.should match("<h1>Hello Rango!</h1>")
    end

    it "should works with instance variables" do
      pending "Without binding instance variables don't work" do
        @title = "Hello There!"
        body = @engine.render(@template)
        body.should match("<h1>Hello There!</h1>")
      end
    end

    it "should use class from Project.settings.erubis.custom_class" do
      MockedEruby = mock("Erubis::MockedEruby")
      options = {pattern: Project.settings.erubis.pattern, filename: @template.path}
      content = @template.read
      engine  = Erubis::Eruby.new(content, options)
      MockedEruby.should_receive(:new).with(content, options).and_return(engine)
      Project.settings.erubis.custom_class = MockedEruby
      @engine.render(File.new(@template.path))
    end

    it "should Project.settings.erubis.pattern" do
      pending "Probably Erubis problem" do
        Project.settings.erubis.pattern = "[$ $]"
        file = edit_template { |content| content.gsub("<%", "[$").gsub("<%", "[$") }
        body = @engine.render(file)
        body.should match("<h1>")
        body.should match("3#")
      end
    end

    it "should point to proper file and line" do
      begin
        @engine.render(@template)
      rescue Exception => exception
        path, line, where = exception.backtrace.first.split(":")
        path.should eql("")
        line.should == "1"
      end
    end

    describe "autoescaping" do
      before(:each) do
        @template = template("context.html.erb")
      end

      it "should autoescape evaluated expression if Project.settings.autoescape is true" do
        Project.settings.template.autoescape = true
        body = @engine.render(@template, who: "<b>Rango</b>")
        body.should match("<h1>Hello &lt;b&gt;Rango&lt;/b&gt;!</h1>")
      end

      it "should not autoescape evaluated expression if Project.settings.autoescape is false" do
        Project.settings.template.autoescape = false
        body = @engine.render(@template, who: "<b>Rango</b>")
        body.should match("<h1>Hello <b>Rango</b>!</h1>")
      end
    end

    describe "caching" do
      after(:each) { clean_cache }    
      it "should cache templates if Project.settings.template.caching is true" do
        Project.settings.template.caching = true
        @engine.render(@template)
        File.exist?("#{@template.path}.cache").should be_true
      end
      
      it "should not cache templates if Project.settings.template.caching is false" do
        Project.settings.template.caching = false
        @engine.render(@template)
        File.exist?("#{@template.path}.cache").should be_false
      end
    end
  end
end

describe "[ErubisClass]" do
  include TemplateHelpers
  before(:each) do
    @engine   = Rango::Templates::ErubisAdapter.new
    @template = template("capture.html.erb")
    Project.settings = settings(erubis: {pattern: "<% %>", custom_class: nil})
  end

  describe "#capture_erubis" do
    it "should returns captured block" do
      pending "Not implemented yet" do
        body = @engine.render(@template)
        raise body.inspect ####
        body.should match("<li>1</li>")
      end
    end
  end
end
