require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hats/show.html.erb" do
  include HatsHelper
  
  before(:each) do
    assigns[:hat] = @hat = stub_model(Hat,
      :color => "Foo",
      :summary => "value for summary",
      :description => "value for description\n\n* bullet",
      :more_info => "value for more_info"
    )
  end

  it_should_behave_like "a view"
  def do_action
    render "/hats/show.html.erb"
  end

  it "should render attributes in <p>" do
    template.should_receive(:content_for).with(:instructions)

	do_action
    assigns[:title].should == "About the Foo Hat"
    response.should have_text(/value\ for\ description/)
    response.should_not have_text(/value\ for\ more_info/)

  end
  it "should render the description as Markdown" do 
    do_action
    response.should have_tag( "ul>li", "bullet" )
  end
  describe "should not show edit links" do
    def do_action
      do_login(@u)
      assigns[:hat] = @hat = Hat.find(:first)
      render "/hats/show.html.erb"
      response.should_not have_tag("a[href=#{edit_hat_path(@hat)}]")
    end
    it "when not logged in" do
      @u = nil
      do_action
    end
    it "when not logged in" do
      @u = Factory(:user) 
      do_action
    end
  end

end

