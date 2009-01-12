require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Thought do
  before(:each) do
    @valid_attributes = {
      :summary => "MyString",
      :detail => "MyText",
    }
  end

  it "should create a new instance given valid attributes" do
    Thought.create!(@valid_attributes)
  end
end
