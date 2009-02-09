require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TopicsController do

  def no_login_context
    # no special context needed for this controller's no-login tests
  end
  def assemble_belonging(user)
    @topic = Factory(:topic, :user => user)
    {
      :belonging => @topic,
      :assigns => :topic,
      :or_redirect => topics_url
    }   
  end

  describe "responding to GET index" do
    it_should_behave_like "login required"
    def do_action(user=nil)
      get :index
    end

    describe "when there are topics" do
      before do
        do_login( @user = Factory( :user ))
        @tlist = [1..5].map { |n| Factory( :topic, :user => @user ) }
      end

      it "should expose all topics as @topics" do
        do_action
        assigns[:topics].should == @tlist
      end
    
      describe "with mime type of xml" do
        it "should render all topics as xml" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          do_action
          response.body.should == @tlist.to_xml
        end
      end
    end
    
    describe "when there are no topics" do
      it "should render the topic creation page instead" do
        do_login( @user = Factory(:user) )
        do_action
        response.should redirect_to(new_topic_url)
        flash[:notice].should_not be_blank
      end
    end
  end

  describe "responding to GET show" do

    def do_action(topic=nil)
      get :show, :id => topic ? topic.id : 2987234
    end
    it_should_behave_like "login required"
    it_should_behave_like "belongs to me"

    it "should expose the requested topic as @topic" do
      @topic = Factory(:topic)
      do_login( @topic.user )
      do_action(@topic)
      assigns[:topic].should == @topic
      assigns[:thoughts].should == []
    end
    
    describe "with mime type of xml" do
      it "should render the requested topic as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        @topic = Factory(:topic)
        do_login( @topic.user )
        do_action( @topic )
        response.should have_tag( "topic" ) do 
          with_tag("thoughts")
        end
      end
    end
  end

  describe "responding to GET new" do
    def do_action(topic=nil)
      get :new
    end
    it_should_behave_like( "login required" )
    
    it "should expose a new topic as @topic" do
      do_login( @u = Factory(:user) )
      do_action
      assigns[:topic].should_not be_nil
      assigns[:topic].user_id.should == @u.id
      assigns[:topic].should be_new_record
    end
  end

  describe "responding to GET edit" do
    def do_action(topic=nil)
      get :edit, :id => topic ? topic.id : 239879238742
    end
    it_should_behave_like "login required"
    it_should_behave_like "belongs to me"

    it "should expose the requested topic as @topic" do
      @t = Factory(:topic)
      do_login( @t.user )
      do_action( @t )
      assigns[:topic].should == @t
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      def do_action(user=nil)
        topic = {:name => 'name', :summary => 'summary'}
        topic[:user_id] = user.id if user
        post :create, :topic => topic
      end
      it_should_behave_like "login required"
      describe " - posting to a different userid" do
        before do
          do_login( Factory(:user) )
          @other = Factory(:user)
          do_action(@other)
        end
        it "should not be allowed" do
          response.should_not be_success
        end
        it "should redirect to the topic list" do
          response.should redirect_to(topics_url)
        end
        it "should show an error message" do
          flash[:warning].should =~ /Permission denied/i
        end
        describe "in an XML request" do
          before do
            request.env["HTTP_ACCEPT"] = "application/xml"
            do_login( Factory(:user) )
            @other = Factory(:user)
            do_action(@other)
          end
          it "should not be allowed" do
            response.should_not be_success
          end
        end
      end
      describe "on success" do
        before do
          @user = Factory(:user)
          @user.state = 'active'; @user.save
          do_login(@user)
          debugger
          do_action(@user)
          response.should_not redirect_to(topics_url)

          @user = User.find_by_id( @user.id )
          @topic = @user.topics.first
        end
        it "should expose a newly created topic as @topic" do
          @user.topics.length.should == 1
          assigns(:topic).should == @topic

        end
        it "should redirect to the created topic" do
          response.should redirect_to(topic_url(@topic))
        end
      end
    end

    describe "with invalid params" do
      before do
        @topic = Factory.build(:topic, :name => 'f')
        do_login( @topic.user )
        post :create, :topic => { :name => @topic.name }
      end
      it "should be testing what we think we're testing" do
        @topic.valid?.should_not be_true
      end
      
      it "should expose a newly created but unsaved topic as @topic" do
        assigns(:topic).new_record?.should be_true
      end
  
      it "should re-render the 'new' template" do
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT update" do

    describe "with valid params" do
      def do_action(topic=nil, user=nil)
        topic = {:summary => 'updated summary'}
        topic[:user_id] = user.id if user
        put :update, :id => ( @topic ? @topic.id : 23423243 ) , :topic => topic
      end
      it_should_behave_like "login required"

      before do
        @topic = Factory(:topic)
        do_login(@topic.user)
      end
      describe " - posting to a different userid" do
        before do
          do_login( @other = Factory(:user) )
        end
        it "should not be allowed" do
          do_action( @topic, @other )
          response.should_not be_success
          response.should redirect_to(topics_url)
        end
        it "should not be allowed for XML" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          do_action( @topic, @other )
          response.should_not be_success
          response.should_not redirect_to(topics_url)
          response.should_not be_redirect
        end
      end
    
      it "should update the requested topic" do
        do_action( @topic )
        @updated = @topic.user.topics.find_by_id( @topic.id )
        @updated.summary.should == "updated summary"
      end

      it "should redirect to the topic" do
        do_action( @topic )
        response.should redirect_to( topic_url( @topic ) )
      end
#     describe "(in-place editing)" do
#       it "should respond to an xhr request with the new field value"
#     end

    end
    
    describe "with invalid params" do
      before do
        @topic = Factory(:topic)
        do_login(@topic.user)
  
        put :update, :id => @topic.id, :topic => { :name => 'f' }
      end

      it "should expose the topic as @topic" do
        assigns(:topic).should == @topic
      end

      it "should re-render the 'edit' template" do
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it_should_behave_like "login required"
    it_should_behave_like "belongs to me"

    def do_action(topic=nil)
      delete :destroy, :id => topic ? topic.id : 2342342
    end
    describe "when logged in" do
      before do
        @topic = Factory(:topic)
        do_login( @topic.user )
        do_action(@topic)
      end
      it "should destroy the requested topic" do
        Topic.find_by_id( @topic.id ).should be_nil
      end
    
      it "should redirect to the topics list" do
        response.should redirect_to(topics_url)
      end
    end
  end

end
