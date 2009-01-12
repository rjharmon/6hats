
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../spec_shared_model'

describe Hat do
  before(:each) do
    @valid_attributes = {
      :color => "value for color",
      :description => "value for description",
      :more_info => "value for more_info",
      :summary => "value for summary"
    }
  end

  it "should create a new instance given valid attributes" do
    Hat.create!(@valid_attributes)
  end
end
