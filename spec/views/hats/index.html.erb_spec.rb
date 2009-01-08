require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hats/index.html.erb" do
  include HatsHelper
  
  before(:each) do
    assigns[:hats] = [
      stub_model(Hat,
        :color => "value for color",
        :summary => "value for summary"
      ),
      stub_model(Hat,
        :color => "value for color",
        :summary => "value for summary"
      )
    ]
  end

  it "should render list of hats" do
    render "/hats/index.html.erb"
    response.should have_tag("tr>td", "value for color", 2)
    response.should have_tag("tr>td", "value for summary", 2)
  end
end

