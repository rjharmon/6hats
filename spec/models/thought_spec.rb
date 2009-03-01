# == Schema Information
# Schema version: 20090209051856
#
# Table name: thoughts
#
#  id         :integer         not null, primary key
#  topic_id   :integer
#  summary    :string(255)
#  detail     :text
#  hat_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Thought do
  before(:each) do
    @valid_attributes = {
      :summary => "MyString",
      :detail => "MyText",
    }
  end

  it "should have one topic" do
  	t = Thought.new
  	topic = Topic.new
  	t.topic = topic
  	t.topic.should == topic
  end

  it "should create a new instance given valid attributes" do
    Thought.create!(@valid_attributes)
  end
end
