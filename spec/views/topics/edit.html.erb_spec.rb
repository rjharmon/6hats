require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/edit.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topic] = @topic = stub_model(Topic,
      :new_record? => false,
      :name => "value for name"
    )
  end

  it "should render edit form" do
    render "/topics/edit.html.erb"
    
    response.should have_tag("form[action=#{topic_path(@topic)}][method=post]") do
      with_tag('input#topic_name[name=?]', "topic[name]")
    end
  end
end


