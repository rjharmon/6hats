require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ApplicationHelper
include UsersHelper
include AuthenticatedTestHelper

describe HomeController do


  describe "responding to GET /" do 
# TODO: move this to an integration test (Cucumber)
	before do
		@user = mock_user
	end
	describe "(route)" do
		it "should route index to /" do
			route_for( :controller => 'home', :action => "index" ).should == '/'
		end
	end
	describe "when user is logged out" do
		before do 
			stub!(:current_user).and_return(nil)	
		end
		it "should temporarily show all topics" do
			get "index"
			response.should redirect_to( hats_url )
		end
	end
	#		response.should render_template( "topics/index.rhtml.erb" )

	describe "when user is logged in" do
		before do 
			stub!(:current_user).and_return(@user)
		end
		it "should introduce the concept of 6 hats" do
			get "index"
			response.should redirect_to( hats_url )
		end
	end
  end

end
