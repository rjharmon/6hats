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
  def do_action 
     render "/topics/new.html.erb"
     return [ "new", "topic" ]
  end

  it "should render new form" do
    do_action
    
    response.should have_tag("form[action=?][method=post]", topics_path) do
      with_tag("input#topic_name[name=?]", "topic[name]")
      with_tag("input#topic_summary[name=?]", "topic[summary]")
    end
  end
end


