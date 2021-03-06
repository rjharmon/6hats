require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/show.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:thoughts] = [
      stub_model(Thought, :hat_id => 1, :summary => "sum1", :detail => "desc1" ),
      stub_model(Thought, :hat_id => 2, :summary => "sum2", :detail => "desc2" ),
      stub_model(Thought, :hat_id => 3, :summary => "sum3", :detail => "desc3\n\n* a\n* b" )
    ]
    assigns[:topic] = @topic = stub_model(Topic,
      :name => "value for name",
      :summary => "value for summary"
    )
  end

  it_should_behave_like "a view"
  def do_action
    render "/topics/show.html.erb"
  end

  it "should render thoughts/index" do
    template.should_receive(:render).with(:file => 'thoughts/index')
    do_action
  end
  describe "when rendering" do
    before :each do
      do_action
    end

    it "should render attributes in <p>" do
      assigns[:title].should == "value for name"
    end
    it "should display the topic summary text" do
      content_for(:instructions).should have_text(/value\ for\ summary/)
    end
    
    it "should show the thoughts for this topic" do
      response.should have_text( /sum1/ )
      response.should have_text( /sum2/ )
      response.should have_text( /sum3/ )
      response.should have_tag( "li", "a" )
    end

    it "should have pretty buttons" do
      response.should have_tag( "a.button#edit_topic" )
      response.should have_tag( "a.button#new_thought" )
    end
  end
end

