require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/edit.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:thought] = @thought = stub_model(Thought,
      :new_record? => false,
      :summary => "value for summary",
      :description => "value for description"
    )
    assigns[:topic] = @topic = stub_model(Topic,
      :new_record? => false,
      :name => 'foobar'
    )
  end

  it "should render edit form" do
    render "/thoughts/edit.html.erb"
    
    response.should have_tag("form[action=#{topic_thought_path(@topic,@thought)}][method=post]") do
      with_tag('input#thought_summary[name=?]', "thought[summary]")
      with_tag('textarea#thought_description[name=?]', "thought[description]")
    end
  end
end


