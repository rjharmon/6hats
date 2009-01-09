require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/index.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:topic] = stub_model(Thought, :id => 42 )
    assigns[:thoughts] = [
      stub_model(Thought,
        :summary => "value for summary",
        :description => "value for description",
        :topic => assigns[:topic],
	:topic_id => 42
      ),
      stub_model(Thought,
        :summary => "value for summary",
        :description => "value for description",
        :topic => assigns[:topic],
	:topic_id => 42
      )
    ]
  end

  it "should render list of thoughts" do
    render "/thoughts/index.html.erb"
    response.should have_tag("tr>td", "value for summary", 2)
    response.should have_tag("tr>td", "value for description", 2)
  end
end

