require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe "Rango::Authentication.customizations" do

  before(:each) do
    Rango::Authentication.default_customizations.clear
  end

  it "should allow addition to the customizations" do
    Rango::Authentication.customize_default { "ONE" }
    Rango::Authentication.default_customizations.first.call.should == "ONE"
  end

  it "should allow multiple additions to the customizations" do
    Rango::Authentication.customize_default {"ONE"}
    Rango::Authentication.customize_default {"TWO"}

    Rango::Authentication.default_customizations.first.call.should == "ONE"
    Rango::Authentication.default_customizations.last.call.should  == "TWO"
  end

end
