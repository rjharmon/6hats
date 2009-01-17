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

  it_should_behave_like "a view"
  def do_action
    render "/topics/index.html.erb"
  end
    it "should show a title" do
	do_action
    	assigns[:title].should == "Topics"
    end
    it "should show intro text" do
	do_action
    	content_for( :instructions ).should have_text( /topic.*thought/i )
    end

  it "should render list of topics" do
	do_action
    response.should have_tag("tr>td", "value for name", 2)
  end
end

