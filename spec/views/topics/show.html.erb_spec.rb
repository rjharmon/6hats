require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/show.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:thoughts] = [
	stub_model(Thought, :hat_id => 1, :summary => "sum1", :description => "desc1" ),
	stub_model(Thought, :hat_id => 2, :summary => "sum2", :description => "desc2" ),
	stub_model(Thought, :hat_id => 3, :summary => "sum3", :description => "desc3" )
    ]
    assigns[:topic] = @topic = stub_model(Topic,
      :name => "value for name"
    )
  end

  it_should_behave_like "a view"
  def do_action
    render "/topics/show.html.erb"
  end
  it "should render attributes in <p>" do
    template.should_receive(:render).with(:file => 'thoughts/index')
    render "/topics/show.html.erb"
    response.should have_text(/value\ for\ name/)
  end
  
  it "should show the thoughts for this topic"
  
end

