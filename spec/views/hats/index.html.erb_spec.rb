require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hats/index.html.erb" do
  include HatsHelper
  include UsersHelper  
  before(:each) do
    assigns[:hats] = @hats = [
      stub_model(Hat,
        :color => "value for color",
        :summary => "value for summary"
      ),
      stub_model(Hat,
        :color => "value for color",
        :summary => "value for summary"
      )
    ]
    @user = stub_model( User );
  end

  it_should_behave_like "a view"
  def do_action
    render "/hats/index.html.erb"
  end
  describe "when user is not logged in" do
    before :each do
      do_login(nil)
      assigns[:hats] = @hats = Hat.find(:all)
    end
    it "should link to the login and register page" do
      render '/hats/index.html.erb', :layout => 'application.html.erb'
      response.should     have_tag( "a[href=#{login_path}]" )
      response.should     have_tag( "a[href=#{register_path}]" )
    end
  end
  describe "when user is logged in" do
    before :each do
      @user = Factory(:user);
      do_login(@user)
      assigns[:hats] = @hats = Hat.find(:all)
    end
    it "should not link to login/register" do
      render '/hats/index.html.erb', :layout => 'application.html.erb'
      response.should_not have_tag( "a[href=#{login_path}]" )
      response.should_not have_tag( "a[href=#{register_path}]" )
    end
  end

  describe "should not show edit links" do
    def do_action
      do_login(@u)
      assigns[:hats] = @hats = Hat.find(:all)
      render "/hats/index.html.erb"
      Hat.find(:all).each do |hat|
        response.should_not have_tag("a[href=#{edit_hat_path(hat)}]")
      end
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

  it "should show benefits and contrast with argumentative style" do
    render "/hats/index.html.erb"
    content_for( :right ).should have_text(/Problems.*Argument/mi)
    content_for( :left ).should have_text(/More Objectivity/mi)
    content_for( :left ).should have_text(/More Innov/mi)
    content_for( :left ).should have_text(/More.*Heard/mi)
    content_for( :left ).should have_text(/Shorter Meetings/mi)
  end


end

