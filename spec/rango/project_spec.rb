# encoding: utf-8

require File.join(Dir.pwd, "spec", "spec_helper")

describe Project do
  it "should have root" do
    Project.should respond_to(:root)
    Project.root.should be_kind_of(String)
  end

  it "should have path which is similar as root, but it is Path, not String" do
    Project.should respond_to(:path)
    Project.path.should be_kind_of(Path)
  end

  it "should respond to name" do
    Project.should respond_to(:name)
    Project.name.should eql("rango") # it's derived from Dir.pwd
  end

  it "should have settings" do
    Project.should respond_to(:settings)
    Project.setttings.should be_kind_of(Rango::Settings::Framework)
  end

  it "should have router" do
    Project.should respond_to(:router)
  end

  it "should have logger" do
    Project.should respond_to(:logger)
    Project.logger.should be_kind_of(Rango::Logger)
  end

  describe ".import" do
    # TODO
  end

  describe ".import!" do
    # TODO
  end

  describe ".configure" do
    # TODO
  end
end