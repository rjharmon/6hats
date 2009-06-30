require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ThoughtsController do
  describe "route generation" do
    it "should NOT map #index" do
#      { :get => "/thoughts/" }.should_not be_routable
    end
    it "should NOT map #show" do
 #     { :get => "/thoughts/1" }.should_not be_routable
    end
  
    it "should map #new" do
      route_for(:controller => "thoughts", :action => "new", :topic_id => "1").should == "/topics/1/thoughts/new"
    end
    it "should map #edit" do
      route_for(:controller => "thoughts", :action => "edit", :id => "1", :topic_id => "1").should == "/topics/1/thoughts/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "thoughts", :action => "update", :id => "1", :topic_id => "1").should == { :path => "/topics/1/thoughts/1", :method => :put }
    end
  
    it "should map #destroy" do
      route_for(:controller => "thoughts", :action => "destroy", :id => "1", :topic_id => "1").should == { :path => "/topics/1/thoughts/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/topics/1/thoughts/new").should == {:controller => "thoughts", :action => "new", :topic_id => "1"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/topics/1/thoughts").should == {:controller => "thoughts", :action => "create", :topic_id => "1"}
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
