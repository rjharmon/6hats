require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/thoughts/new.html.erb" do
  include ThoughtsHelper
  
  before(:each) do
    assigns[:thought] = stub_model(Thought,
      :new_record? => true,
      :summary => "value for summary",
      :description => "value for description"
    )
  end

  it "should render new form" do
    render "/thoughts/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", thoughts_path) do
      with_tag("input#thought_summary[name=?]", "thought[summary]")
      with_tag("textarea#thought_description[name=?]", "thought[description]")
    end
  end
end


