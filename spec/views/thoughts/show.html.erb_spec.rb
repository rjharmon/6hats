require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/show.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:topic] = stub_model(Topic)
    assigns[:thought] = @thought = stub_model(Thought,
      :summary => "MyString",
      :detail => "MyText"
    )
  end

  it_should_behave_like "a view"
  def do_action
    render "/thoughts/show.html.erb"
  end
  it "should render attributes in <p>" do
    render "/thoughts/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
  end
end

