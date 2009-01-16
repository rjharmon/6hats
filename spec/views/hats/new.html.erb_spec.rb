require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hats/new.html.erb" do
  include HatsHelper
  
  before(:each) do
    assigns[:hat] = stub_model(Hat,
      :new_record? => true,
      :color => "value for color",
      :summary => "value for summary",
      :description => "value for description",
      :more_info => "value for more_info"
    )
  end

  def do_action 
     render "/hats/new.html.erb"
     return [ "new", "hat" ]
  end
  it_should_behave_like( "a form" )

  it "should render new form" do
    render "/hats/new.html.erb"
  
    response.should have_tag("form[action=?][method=post]", hats_path) do
      with_tag("input#hat_color[name=?]", "hat[color]")
      with_tag('input#hat_summary[name=?]', "hat[summary]")
      with_tag("textarea#hat_description[name=?]", "hat[description]")
      with_tag("textarea#hat_more_info[name=?]", "hat[more_info]")
    end
  end
end


