require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/edit.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:topic] = @topic = stub_model(Topic)
    assigns[:thought] = @thought = stub_model(Thought,
      :new_record? => false,
      :summary => "MyString",
      :detail => "MyText"
    )
  end

  it_should_behave_like "a view"
  def do_action
    render "/thoughts/edit.html.erb"
  end

  it "should render edit form" do
    render "/thoughts/edit.html.erb"
    
    response.should have_tag("form[action=#{topic_thought_path(@topic, @thought)}][method=post]") do
      with_tag('input#thought_summary[name=?]', "thought[summary]")
      with_tag('textarea#thought_detail[name=?]', "thought[detail]")
    end
  end
end


