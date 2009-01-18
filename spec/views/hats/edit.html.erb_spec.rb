require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hats/edit.html.erb" do
  include HatsHelper
  
  before(:each) do
    assigns[:hat] = @hat = stub_model(Hat,
      :new_record? => false,
      :color => "value for color",
      :summary => "value for summary",
      :description => "value for description",
      :more_info => "value for more_info"
    )
  end

  it_should_behave_like( "a form" )
  it_should_behave_like( "a view" )
  def do_action
    render "/hats/edit.html.erb"
    return [ "edit", "hat" ]
  end


  
  it "should render edit form" do
    render "/hats/edit.html.erb"
    
    response.should have_tag("form[action=#{hat_path(@hat)}][method=post]") do
      with_tag('input#hat_color[name=?]', "hat[color]")
      with_tag('input#hat_summary[name=?]', "hat[summary]")
      with_tag('textarea#hat_description[name=?]', "hat[description]")
      with_tag('textarea#hat_more_info[name=?]', "hat[more_info]")
      with_tag("input[type='submit']")
    end
  end
end


