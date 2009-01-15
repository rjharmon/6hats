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
    render "/topics/index.html.erb"
  end

    it "should show a title" do
    	assigns[:title].should == "Topics"
    end
    it "should show intro text" do
    	content_for( :instructions ).should have_text( /topic.*thought/i )
    end

  it "should render list of topics" do
    response.should have_tag("tr>td", "value for name", 2)
  end
end

