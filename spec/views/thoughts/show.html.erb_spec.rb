require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/show.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:thought] = @thought = stub_model(Thought,
      :summary => "value for summary",
      :description => "value for description",
      :topic_id => 42
    )
    assigns[:topic] = @topic = stub_model(Topic,
      :name => 'foobar',
      :id => 42
    )
  end

  it "should render attributes in <p>" do
    render "/thoughts/show.html.erb"
    response.should have_text(/value\ for\ summary/)
    response.should have_text(/value\ for\ description/)
  end
end

