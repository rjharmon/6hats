require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/new.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topic] = stub_model(Topic,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "should render new form" do
    render "/topics/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", topics_path) do
      with_tag("input#topic_name[name=?]", "topic[name]")
    end
  end
end


