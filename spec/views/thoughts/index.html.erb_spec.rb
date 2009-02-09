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

  def do_action
    render "/thoughts/index.html.erb"
  end
  describe "when rendering" do
    before :each do
      do_action
    end
    
    it "should render list of thoughts" do
      response.should have_tag("tr>td", "MyString", 2)
      response.should have_tag("tr>td", "MyText", 2)
    end
    it "should not try to replace the page title, as the view is used only as a subsidiary view" do
  	  assigns[:title].should be_nil
    end
  end
end
