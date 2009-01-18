require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/edit.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topic] = @topic = stub_model(Topic,
      :new_record? => false,
      :name => "value for name",
      :summary => "value for summary"
    )
  end

  it_should_behave_like "a view"
  it_should_behave_like( "a form" )
  def do_action
    render "/topics/edit.html.erb"
    return [ "edit", "topic" ]
  end
  it "should render edit form" do
    do_action    
    response.should have_tag("form[action=#{topic_path(@topic)}][method=post]") do
      with_tag('input#topic_name[name=?]', "topic[name]")
      with_tag('textarea#topic_summary[name=?]', "topic[summary]")
    end
  end
end


