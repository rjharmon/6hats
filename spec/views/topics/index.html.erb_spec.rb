require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/index.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topics] = [
      stub_model(Topic,
        :name => "value for name"
      ),
      stub_model(Topic,
        :name => "value for name"
      )
    ]
  end

  it "should render list of topics" do
    render "/topics/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
  end
end

