require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/index.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:topic] = stub_model(Topic)
    assigns[:thoughts] = [
      stub_model(Thought,
        :summary => "MyString",
        :detail => "MyText"
      ),
      stub_model(Thought,
        :summary => "MyString",
        :detail => "MyText"
      )
    ]
  end

  it "should render list of thoughts" do
    render "/thoughts/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
  end
end
