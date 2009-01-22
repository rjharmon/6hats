require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TopicsController do

  def mock_topic(stubs={})
    @mock_topic ||= mock_model(Topic, stubs)
  end
  
  def mock_user(userid=1, stubs={})
    @mock_user = userid ? mock_model(User, stubs.reverse_merge(:topics => mock('Array of Topics'), :id => userid)) : nil
    @request.session[:userid] = userid
    User.should_receive(:find).with(userid).and_return(@mock_user) if userid
    return @mock_user
  end
  
  before(:each) do
  end

  describe "belongs to me", :shared => true do
  	it "should not be actionable if it doesn't belong to me"
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
	def do_action
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

	def do_action
		get :show, :id => "37"
	end
	it_should_behave_like "login required"
	it_should_behave_like "belongs to me"

    it "should deny access to a topic that doesn't belong to me"

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
	def do_action
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

    def do_action
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

    describe "with valid params" do
	def do_action
	        post :create, :topic => {:these => 'params'}
	end
	it_should_behave_like "login required"
	it "should not allow the user to post a userid that's different than theirs"
    
      it "should expose a newly created topic as @topic" do
        mock_user.topics.should_receive(:build).with({'these' => 'params'}).and_return(mock_topic(:save => true))
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
    describe "with valid params" do

	def do_action
	        put :update, :id => "37", :topic => {:these => 'params'}
	end
	it_should_behave_like "login required"
	it_should_behave_like "belongs to me"
	it "should not allow the user to post a userid that's different than theirs"

      it "should update the requested topic" do
        mock_user.topics.should_receive(:find).with("37").and_return(mock_topic)
        mock_topic.should_receive(:update_attributes).with({'these' => 'params'})
	do_action
      end

      it "should expose the requested topic as @topic" do
        mock_user.topics.stub!(:find).and_return(mock_topic(:update_attributes => true))
	do_action
        assigns(:topic).should equal(mock_topic)
      end

      it "should redirect to the topic" do
	@u = mock_user(1)
	topic = mock_topic({ :update_attributes => true })
        @u.topics.should_receive(:find).with("37").and_return(topic)
	do_action
        response.should redirect_to( topic_url( topic ) )
      end
#      describe "(in-place editing)" do
#      	it "should respond to an xhr request with the new field value"
#      end

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
    def do_action
      delete :destroy, :id => "1"
    end
    it_should_behave_like "login required"
    it_should_behave_like "belongs to me"

    it "should destroy the requested topic" do
      mock_user.topics.should_receive(:find).with("1").and_return(mock_topic)
      mock_topic.should_receive(:destroy)
	do_action
    end
  
    it "should redirect to the topics list" do
      mock_user.topics.stub!(:find).and_return(mock_topic(:destroy => true))
	do_action
      response.should redirect_to(topics_url)
    end

  end

end
