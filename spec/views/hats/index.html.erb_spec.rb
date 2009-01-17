require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hats/index.html.erb" do
  include HatsHelper
  include UsersHelper  
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
    @user = stub_model( User );
  end

  it_should_behave_like "a view"
  def do_action
    render "/hats/index.html.erb"
  end

  describe "layout" do

	it "should do better than this :("	
	[true, false]
	[].each do |state|
		in_or_not = state ? "logged in" : "not logged in"

		describe "when user is #{in_or_not}" do
			before :each do
				debugger
				render '/hats/index.html.erb', :layout => 'application.html.erb'
				assigns[:current_user] = state ? @user : nil
			# this breaks things :(
			#	stub!( :logged_in? ).any_number_of_times.and_return( state );
			end
			it "should #{state ? 'not' : ''} link to the login and register page" do
				debugger
				if( state ) then
					response.should_not have_tag( "a[href=#{login_path}]" )
					response.should_not have_tag( "a[href=#{register_path}]" )
				else
					response.should     have_tag( "a[href=#{login_path}]" )
					response.should     have_tag( "a[href=#{register_path}]" )
				end
			end
		end
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

  it "should show benefits on the right" do
    render "/hats/index.html.erb"
    content_for( :right ).should have_text(/Problems.*Argument/mi)
    content_for( :right ).should have_text(/More Objectivity/mi)
    content_for( :right ).should have_text(/More Innov/mi)
    content_for( :right ).should have_text(/More.*Heard/mi)
    content_for( :right ).should have_text(/Shorter Meetings/mi)
  end


end

