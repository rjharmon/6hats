require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hats/show.html.erb" do
  include HatsHelper
  
  before(:each) do
    assigns[:hat] = @hat = stub_model(Hat,
      :color => "value for color",
      :summary => "value for summary",
      :description => "value for description",
      :more_info => "value for more_info"
    )
  end

  it "should render attributes in <p>" do
    render "/hats/show.html.erb"
    response.should have_text(/value\ for\ color/)
    response.should have_text(/value\ for\ summary/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/value\ for\ more_info/)
  end
end

