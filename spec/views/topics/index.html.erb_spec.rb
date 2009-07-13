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

  describe "when rendering" do
    before :each do
      do_action
    end
    it "should show a title" do
      assigns[:title].should == "Topics"
    end
    it "should render list of topics" do
      response.body.should have_text( /value for name/, 2)
    end
  end
end

