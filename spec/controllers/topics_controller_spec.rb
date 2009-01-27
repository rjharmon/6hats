require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TopicsController do

	def mock_topic(stubs={})
		@mock_topic ||= mock_model(Topic, stubs)
	end
  
	def mock_user(userid=1, stubs={})
  
		@mock_user = userid ? mock_model(User, stubs.reverse_merge(:topics => mock('Array of Topics'), :id => userid)) : nil
		@request.session[:user_id] = userid
		User.should_receive(:find).with(:first, {:conditions=>{:id=>userid}}).and_return(@mock_user) if userid
		return @mock_user
	end

	def login( user ) 
		@request.session[:user_id] = user.id
	end

	before do
		Factory.sequence :name do |n|
			"Joe Gunchi #{n}"
		end
		Factory.sequence :login do |n|
			"login#{n}"
		end
		Factory.sequence :email do |n|
			"person#{n}@example.com" 
		end
		Factory.sequence :random_string do |n|
			require 'digest/sha1'
			sha1 = Digest::SHA1.hexdigest("#{n}")
		end
		  
		Factory.define :user do |u|
			u.login { |l| Factory.next :login }
			u.name { |n| Factory.next :name }
			u.email { |e| Factory.next :email }
			u.password { |e| "password" }
			u.password_confirmation { |e| "password" }
			
			u.state 'active'
		end
		Factory.define :topic do |t|
			t.name { |n| Factory.next :random_string }
			t.summary { |s| Factory.next :random_string }
			t.user { |u| u.association( :user ) }
		end
	end  

	def is_a_post ; false ; end
	def is_new ; false ; end
	def shared_setup ; end
	describe "belongs to me", :shared => true do
		it "should belong to me - else, should not be actionable" do
			unless is_new  	
				mock_user(192).topics.should_receive(:find).and_return(nil)
			end
			do_action(192)
			assigns[:topic].should be_nil
		end
		describe " - posting to a different userid" do
			it "should not be allowed" do
				if( is_a_post )
					session[:user_id] = 1
					shared_setup()
					do_action(129)
					response.should_not be_success
					response.should redirect_to(topics_url)
				end
			end
			it "should not be allowed for XML" do
				if( is_a_post )
					session[:user_id] = 1
					shared_setup()
					do_action(129)
					response.should_not be_success
				end
			end
		end
	end
	describe "login required", :shared => true do
		it "should not be actionable if I'm not logged in" do
			mock_user(nil)
			do_action
			response.should redirect_to( login_url )
			flash[:notice].should_not be_blank
		end
	end

	describe "responding to GET index" do
		def do_action(userid=1)
			get :index
		end
		it_should_behave_like "login required"

		it "should expose all topics as @topics" do
			mock_list = [mock_topic]
			mock_user.topics.should_receive(:find).with(:all).and_return(mock_list)
			do_action
			assigns[:topics].should == [mock_topic]
		end

		describe "with mime type of xml" do
			it "should render all topics as xml" do
				request.env["HTTP_ACCEPT"] = "application/xml"

				mock_list = [mock_topic]
				mock_user.topics.should_receive(:find).with(:all).and_return(mock_list)
			
				mock_list.should_receive(:to_xml).and_return("generated XML")
				do_action
				response.body.should == "generated XML"
			end
		end
		
		describe "when there are no topics" do
			it "should render the topic creation page instead" do
				mock_list = []
				mock_user.topics.should_receive(:find).with(:all).and_return(mock_list)
				do_action
				response.should redirect_to(new_topic_url)
				flash[:notice].should_not be_blank
			end
		end
	end

	describe "responding to GET show" do

		def do_action(userid=37)
			get :show, :id => "37"
		end
		it_should_behave_like "login required"
		it_should_behave_like "belongs to me"

		it "should expose the requested topic as @topic" do
			mock_user.topics.should_receive(:find).with("37").and_return(mock_topic)
			mock_thoughts = ['mock thoughts']
			mock_topic.should_receive(:thoughts).and_return(mock_thoughts)
			do_action
			assigns[:topic].should equal(mock_topic)
			assigns[:thoughts].should equal(mock_thoughts);
		end
		
		describe "with mime type of xml" do
			it "should render the requested topic as xml" do
				request.env["HTTP_ACCEPT"] = "application/xml"
				mock_user.topics.should_receive(:find).with("37").and_return(mock_topic)
				mock_thoughts = [
					mock_model(Thought, { :to_xml => 'xml1' } ),
					mock_model(Thought, { :to_xml => 'xml2' } )
				]
				mock_topic.should_receive(:thoughts).and_return(mock_thoughts)
				mock_topic.should_receive(:to_xml).with( :include => :thoughts ).and_return( "hiya" )
				do_action
				response.should have_text("hiya")
			end
		end
	end

	describe "responding to GET new" do
		def do_action(userid=1)
			get :new
		end
		it_should_behave_like( "login required" )
		
		it "should expose a new topic as @topic" do
			mock_user.topics.should_receive(:build).and_return(mock_topic)
			do_action
			assigns[:topic].should equal(mock_topic)
		end
	end

	describe "responding to GET edit" do
		def do_action(userid=1)
			get :edit, :id => "37"
		end
		it_should_behave_like "login required"
		it_should_behave_like "belongs to me"

		it "should expose the requested topic as @topic" do
			mock_user.topics.should_receive(:find).with("37").and_return(mock_topic)
			do_action
			assigns[:topic].should equal(mock_topic)
		end

	end

	describe "responding to POST create" do
		def is_a_post ;  true ; end
		def is_new ; true ; end

		describe "with valid params" do
			def do_action(userid=nil)
				topic = {:these => 'params'}
				topic[:user_id] = userid if userid
				post :create, :topic => topic
			end
			it_should_behave_like "login required"
			describe "--" do 
				it_should_behave_like "belongs to me"
			end
	
			it "should expose a newly created topic as @topic" do
				mock_user.topics.should_receive(:build).with({ 'these' => 'params'}).and_return(mock_topic(:save => true))
				do_action
				assigns(:topic).should equal(mock_topic)
			end
			it "should redirect to the created topic" do
				mock_user.topics.stub!(:build).and_return(mock_topic(:save => true))
				post :create, :topic => {}
				response.should redirect_to(topic_url(mock_topic))
			end
		end

		describe "with invalid params" do
			it "should expose a newly created but unsaved topic as @topic" do
				mock_user.topics.stub!(:build).with({'these' => 'params'}).and_return(mock_topic(:save => false))
				post :create, :topic => {:these => 'params'}
				assigns(:topic).should equal(mock_topic)
			end
	
			it "should re-render the 'new' template" do
				mock_user.topics.stub!(:build).and_return(mock_topic(:save => false))
				post :create, :topic => {}
				response.should render_template('new')
			end
		end
	end

	describe "responding to PUT update" do
		def is_a_post ; true ; end
		describe "with valid params" do
			def do_action(userid=nil)
				topic = {:these => 'params'}
				topic[:user_id] = userid if userid
				put :update, :id => "37", :topic => topic
			end
			it_should_behave_like "login required"

			describe "--" do
				def shared_setup
					mock_user.topics.should_receive(:find).with("37").and_return(mock_topic)
				end
				it_should_behave_like "belongs to me"
			end
		
			it "should update the requested topic" do
				mock_user.topics.should_receive(:find).with("37").and_return(mock_topic)
				mock_topic.should_receive(:update_attributes).with({'these' => 'params'})
				do_action
			end

			it "should redirect to the topic" do
				topic = mock_topic({ :update_attributes => true })
				mock_user.topics.stub!(:find).and_return(topic)
				do_action
				response.should redirect_to( topic_url( topic ) )
			end
#			describe "(in-place editing)" do
#				it "should respond to an xhr request with the new field value"
#			end

		end
    
		describe "with invalid params" do
			it "should update the requested topic" do
				mock_user.topics.should_receive(:find).with("37").and_return(mock_topic)
				mock_topic.should_receive(:update_attributes).with({'these' => 'params'})
				put :update, :id => "37", :topic => {:these => 'params'}
			end

			it "should expose the topic as @topic" do
				Topic.stub!(:find).and_return(mock_topic(:update_attributes => false))
				mock_user.topics.stub!(:find).and_return(mock_topic(:update_attributes => false))
				put :update, :id => "1"
				assigns(:topic).should equal(mock_topic)
			end

			it "should re-render the 'edit' template" do
				mock_user.topics.stub!(:find).and_return(mock_topic(:update_attributes => false))
				put :update, :id => "1"
				response.should render_template('edit')
			end
		end
	end

	describe "responding to DELETE destroy" do
		def do_action(userid=1)
			delete :destroy, :id => "1"
		end
		it_should_behave_like "login required"
		it_should_behave_like "belongs to me"

		it "should destroy the requested topic" do
			t = Factory(:topic)
			login( t.user )
			delete :destroy, :id => t.id
			Topic.find_by_id( t.id ).should be_nil
		end
  
		it "should redirect to the topics list" do
			mock_user.topics.stub!(:find).and_return(mock_topic(:destroy => true))
			do_action
			response.should redirect_to(topics_url)
		end
	end

end
