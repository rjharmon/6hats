require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Thought do
  before(:each) do
    @valid_attributes = {
      :hat_id => "1",
      :topic_id => "1",
      :summary => "value for summary",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Thought.create!(@valid_attributes)
  end
end
