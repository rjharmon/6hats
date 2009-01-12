require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ThoughtsController do

  def mock_topic(stubs={})
    @mock_topic ||= mock_model(Topic, stubs)
  end

  def mock_thought(stubs={})
    @mock_thought ||= mock_model(Thought, stubs)
  end
  
  describe "responding to GET index" do

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

  describe "responding to GET show" do

    it "should expose the requested thought as @thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Topic.thoughts.should_receive(:find).with("37").and_return(mock_thought)
      get :show, :topic_id => 42, :id => "37"
      assigns[:thought].should equal(mock_thought)
    end
    
    describe "with mime type of xml" do

      it "should render the requested thought as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.should_receive(:find).with("37").and_return(mock_thought)
        mock_thought.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :topic_id => 42
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new thought as @thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
      Thought.should_receive(:new).and_return(mock_thought)
      get :new, :topic_id => 42
      assigns[:thought].should equal(mock_thought)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested thought as @thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
      Thought.should_receive(:find).with("37").and_return(mock_thought)
      get :edit, :id => "37", :topic_id => 42
      assigns[:thought].should equal(mock_thought)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created thought as @thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.should_receive(:new).with({'these' => 'params'}).and_return(mock_thought(:save => true))
        post :create, :thought => {:these => 'params'}, :topic_id => 42
        assigns(:thought).should equal(mock_thought)
      end

      it "should redirect to the created thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic(:id => 42))
        Thought.stub!(:new).and_return(mock_thought(:save => true))
        post :create, :thought => {}, :topic_id => 42
        response.should redirect_to(topic_thought_url(42, mock_thought))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved thought as @thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.stub!(:new).with({'these' => 'params'}).and_return(mock_thought(:save => false))
        post :create, :thought => {:these => 'params'}, :topic_id => 42
        assigns(:thought).should equal(mock_thought)
      end

      it "should re-render the 'new' template" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.stub!(:new).and_return(mock_thought(:save => false))
        post :create, :thought => {}, :topic_id => 42
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.should_receive(:find).with("37").and_return(mock_thought)
        mock_thought.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :thought => {:these => 'params'}, :topic_id => 42
      end

      it "should expose the requested thought as @thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.stub!(:find).and_return(mock_thought(:update_attributes => true))
        put :update, :id => "1", :topic_id => 42
        assigns(:thought).should equal(mock_thought)
      end

      it "should redirect to the thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.stub!(:find).and_return(mock_thought(:update_attributes => true))
        put :update, :id => "1", :topic_id => 42
        response.should redirect_to(topic_thought_url(mock_topic,mock_thought))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.should_receive(:find).with("37").and_return(mock_thought)
        mock_thought.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :thought => {:these => 'params'}, :topic_id => 42
      end

      it "should expose the thought as @thought" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.stub!(:find).and_return(mock_thought(:update_attributes => false))
        put :update, :id => "1", :topic_id => 42
        assigns(:thought).should equal(mock_thought)
      end

      it "should re-render the 'edit' template" do
        Topic.should_receive(:find).with("42").and_return(mock_topic)
        Thought.stub!(:find).and_return(mock_thought(:update_attributes => false))
        put :update, :id => "1", :topic_id => 42
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested thought" do
      Topic.should_receive(:find).with("42").and_return(@mock_topic)
      Thought.should_receive(:find).with("37").and_return(@mock_thought)
      mock_thought.should_receive(:destroy)
      delete :destroy, :id => "37", :topic_id => 42
    end
  
    it "should redirect to the thoughts list" do
      Topic.should_receive(:find).with("42").and_return(mock_topic(:id => 93))
      Thought.stub!(:find).and_return(mock_thought(:destroy => true))
      delete :destroy, :id => "1", :topic_id => 42
      response.should redirect_to(topic_thoughts_url(93))
    end

  end

end
