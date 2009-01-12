require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/new.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:topic] = @topic = stub_model(Topic)
    assigns[:thought] = stub_model(Thought,
      :new_record? => true,
      :summary => "MyString",
      :detail => "MyText"
    )
  end

  it "should render new form" do
    render "/thoughts/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", topic_thoughts_path(@topic)) do
      with_tag("input#thought_summary[name=?]", "thought[summary]")
      with_tag("textarea#thought_detail[name=?]", "thought[detail]")
    end
  end
end


