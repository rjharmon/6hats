require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ThoughtsController do
  def assemble_belonging(user)
    @thought = Factory(:thought, :topic => Factory( :topic, :user => user) )
    {
      :belonging => @thought,
      :assigns => :thought,
      :or_redirect => topics_url
    }    
  end

  describe "NOT responding to GET index" do
    it "should not expose all thoughts" do
      lambda { get :index, :topic_id => 42 }.should raise_error(ActionController::RoutingError)
    end

    describe "with mime type of xml" do
      it "should NOT respond all thoughts as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        lambda { get :index, :topic_id => 42 }.should raise_error(ActionController::RoutingError)
      end
    end  
  end

  describe "NOT responding to GET show" do
    it "should NOT expose the requested thought as @thought" do
      lambda { get :show, :id => "37", :topic_id => "1" }.should raise_error(ActionController::RoutingError)
    end
  end

  describe "responding to GET new" do
    before do
      @topic = Factory(:topic)
      do_login( @topic.user )
    end
    it_should_behave_like "login required"
    def do_action      
      get :new, :topic_id => @topic.id
    end
    it "should expose a new thought as @thought" do
      do_action
      assigns[:thought].new_record?.should be_true
    end
    it " - the new thought should belong to the requested topic" do
      do_action
      assigns[:thought].topic.should == @topic
    end
  end

  describe "responding to GET edit" do
    before do
      @thought = Factory(:thought)
    end

    it_should_behave_like "login required"
    it_should_behave_like "belongs to me"

    def do_action( thought=@thought)
      get :edit, :id => thought.id, :topic_id => thought.topic.id
    end
      
    it "should expose the requested thought as @thought" do
      do_login( @thought.topic.user )
      do_action
      assigns[:thought].should == @thought
    end

  end

  describe "responding to POST create" do

    before do
      @topic = Factory(:topic)
    end
  
    describe "with valid params" do
      it_should_behave_like "login required"

      before do
        do_login( @topic.user )
      end
      def do_action( topic=nil )
        topic ||= @topic
        post :create, :thought => {:summary => 'new summary text'}, :topic_id => topic.id
      end
      describe " - posting to a different userid" do
        before do
          do_login( Factory(:user) )
          @other = Factory(:topic)
        end
        it "should not be allowed" do
          do_action(@other)
          response.should_not be_success
          response.should redirect_to(topics_url)
          flash[:warning].should == "permission denied"
        end
        it "should not be allowed for XML" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          do_action(@other)
          response.should_not be_success
        end
      end
      describe " - on success" do
        before do
          do_login( @topic.user )
          do_action
          response.should_not redirect_to( topics_url )
          response.should_not redirect_to( login_url )
          @topic.reload
        end
        
        it "should expose a newly created thought as @thought" do
          @topic.thoughts.length.should == 1
          assigns(:thought).should == @topic.thoughts[0]
        end
  
        it "should redirect to the topic" do
          response.should redirect_to(topic_url(@topic))
        end
      end
    end
  
    describe "with invalid params" do
      before do
        
        @topic = Factory(:topic)
        do_login(@topic.user)
        post :create, :topic_id => @topic.id, :thought => { :summary => "f" }
      end
      it "should expose a newly created but unsaved thought as @thought" do
        assigns(:thought).new_record?.should be_true
      end
      it "should retain the posted values" do
        assigns(:thought).summary.should == "f"
      end
      
      it "should show errors" do
        pending("fix me")
        flash[:error].should_not be_empty
      end
      
      it "should re-render the 'new' template" do
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT update" do
    it_should_behave_like "login required"
    it_should_behave_like "belongs to me"

    before do
      @thought = Factory(:thought)
      @topic = @thought.topic
    end

    def do_action(topic=@topic)
      puts "doing action"
      put :update, :id => @thought.id, :thought => { :summary => "new summary text" }, :topic_id => topic.id
    end

    describe "with valid params" do
      before do
        @thought = Factory(:thought)
        @topic = @thought.topic
        do_login( @topic.user )
        do_action
        @thought.reload
        @thought = Thought.find(@thought.id)
      end
      it "should update the requested thought" do
        puts "thoughts are "+Thought.find(:all).to_yaml
        @thought.summary.should == "new summary text"
      end

      it "should expose the requested thought as @thought" do
        assigns(:thought).should == @thought
      end

      it "should redirect to the thought" do
        pending "compare implementation and test - topic or thought???"
        response.should redirect_to(topic_url(@topic))
      end

      describe " - posting to a topic owned by a different userid" do
        before do
          @thought = Factory(:thought)
          @topic = @thought.topic
          do_login( @other = Factory(:user) )
          do_action( @topic )
        end
        it "should not be allowed" do
          response.should_not be_success
          response.should redirect_to(topics_url)
        end
        it "should not be allowed for XML" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          do_action( @topic )
          response.should_not be_success
          response.should_not redirect_to(topics_url)
          response.should_not be_redirect
        end
      end
    end
  
    describe "with invalid params" do

      it "should update the requested thought" do
        # !!!
        mock_topic.thoughts.should_receive(:find).with("37").and_return(mock_thought)
        mock_thought.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :thought => {:these => 'params'}, :topic_id => "1"
      end

      it "should expose the thought as @thought" do
        mock_topic.thoughts.stub!(:find).and_return(mock_thought(:update_attributes => false))
        put :update, :id => "1", :topic_id => "1"
        assigns(:thought).should equal(mock_thought)
      end

      it "should re-render the 'edit' template" do
        mock_topic.thoughts.stub!(:find).and_return(mock_thought(:update_attributes => false))
        put :update, :id => "1", :topic_id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "responding to DELETE destroy" do
    it_should_behave_like "login required"
    it_should_behave_like "belongs to me"

    before do
      @thought = Factory(:thought)
      @topic = @thought.topic
      do_login( @topic.user )        
      do_action
    end

    def do_action
      delete :destroy, :id => @thought.id, :topic_id => @topic.id
    end
    it "should destroy the requested thought" do
      @topic.thoughts.find_by_id( @thought.id ).should be_nil
    end
  
    it "should redirect to the thoughts list" do
      response.should redirect_to(topic_url(@topic))
    end

  end

end
