require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/new.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topic] = stub_model(Topic,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it_should_behave_like( "a form" )
  it "should render new form" do
    render "/topics/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", topics_path) do
      with_tag("input#topic_name[name=?]", "topic[name]")
    end
  end
  it "should have a nice title and intro text"
  it "should have a nice Save button"
  it "should have a nice cancel button"
  
  
end


