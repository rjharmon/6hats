require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ThoughtsController do
  describe "route generation" do
    it "should map #index" do
      lambda { route_for(:controller => "thoughts", :action => "index", :topic_id => 1)}.should raise_error( ActionController::RoutingError )
    end
  
    it "should map #new" do
      route_for(:controller => "thoughts", :action => "new", :topic_id => 1).should == "/topics/1/thoughts/new"
    end
  
    it "should map #show" do
      route_for(:controller => "thoughts", :action => "show", :id => 1, :topic_id => 1).should == "/topics/1/thoughts/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "thoughts", :action => "edit", :id => 1, :topic_id => 1).should == "/topics/1/thoughts/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "thoughts", :action => "update", :id => 1, :topic_id => 1).should == "/topics/1/thoughts/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "thoughts", :action => "destroy", :id => 1, :topic_id => 1).should == "/topics/1/thoughts/1"
    end
  end

  describe "route recognition" do
    it "should NOT be able to get /topics/1/thoughts" do
      lambda { params_from(:get, "/topics/1/thoughts")}.should raise_error( ActionController::MethodNotAllowed )
    end
  
    it "should generate params for #new" do
      params_from(:get, "/topics/1/thoughts/new").should == {:controller => "thoughts", :action => "new", :topic_id => "1"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/topics/1/thoughts").should == {:controller => "thoughts", :action => "create", :topic_id => "1"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/topics/1/thoughts/1").should == {:controller => "thoughts", :action => "show", :id => "1", :topic_id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/topics/1/thoughts/1/edit").should == {:controller => "thoughts", :action => "edit", :id => "1", :topic_id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/topics/1/thoughts/1").should == {:controller => "thoughts", :action => "update", :id => "1", :topic_id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/topics/1/thoughts/1").should == {:controller => "thoughts", :action => "destroy", :id => "1", :topic_id => "1"}
    end
  end
end
