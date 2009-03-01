# == Schema Information
# Schema version: 20090209051856
#
# Table name: hats
#
#  id          :integer         not null, primary key
#  color       :string(255)
#  description :text
#  more_info   :text
#  created_at  :datetime
#  updated_at  :datetime
#  summary     :string(255)
#


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
