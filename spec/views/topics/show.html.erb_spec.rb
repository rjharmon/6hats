require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/show.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:thoughts] = [
	stub_model(Thought, :hat_id => 1, :summary => "sum1", :description => "desc1" ),
	stub_model(Thought, :hat_id => 2, :summary => "sum2", :description => "desc2" ),
	stub_model(Thought, :hat_id => 3, :summary => "sum2", :description => "desc2" )
    ]
    assigns[:topic] = @topic = stub_model(Topic,
      :name => "value for name"
    )
  end

  it "should render attributes in <p>" do
    render "/topics/show.html.erb"
    response.should have_text(/value\ for\ name/)
    template.should_receive(:render).with('thoughts/index')
  end
end

