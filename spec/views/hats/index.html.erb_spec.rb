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

  it "should provide a general introduction, outside of the rules for each hat" do 
    template.should_receive(:content_for).once.with(:instructions)
    template.should_receive(:content_for).with(anything()).any_number_of_times
    render "/hats/index.html.erb"
    assigns[:title].should have_text(/Introduction/)
    response.should have_text(/argument.*disadvantage.*alternative.*benefits.*outcomes/m)
  end

  it "should show benefits on the right" do
    render "/hats/index.html.erb"
    content_for( :right ).should have_text(/Problems.*Argument/mi)
    content_for( :right ).should have_text(/More Objectivity/mi)
    content_for( :right ).should have_text(/More Innov/mi)
    content_for( :right ).should have_text(/More.*Heard/mi)
    content_for( :right ).should have_text(/Shorter Meetings/mi)
  end


end

