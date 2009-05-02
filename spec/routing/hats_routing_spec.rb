require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HatsController do
  describe "route generation" do
    it "should route hats/rules properly" do
      route_for(:controller => "hats", :action => "rules").should == "/hats/rules"
    end
    
    it "should map #index" do
      route_for(:controller => "hats", :action => "index").should == "/hats"
    end
  
    it "should map #new" do
      route_for(:controller => "hats", :action => "new").should == "/hats/new"
    end
  
    it "should map #show" do
      route_for(:controller => "hats", :action => "show", :id => "1").should == "/hats/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "hats", :action => "edit", :id => "1").should == "/hats/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "hats", :action => "update", :id => "1").should == { :path => "/hats/1", :method => :put }
    end
  
    it "should map #destroy" do
      route_for(:controller => "hats", :action => "destroy", :id => "1").should == { :path => "/hats/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should recognize the path to the 'rules' action" do 
      params_from(:get, "/hats/rules").should == { :controller => "hats", :action => "rules" }
    end
    it "should generate params for #index" do
      params_from(:get, "/hats").should == {:controller => "hats", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/hats/new").should == {:controller => "hats", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/hats").should == {:controller => "hats", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/hats/1").should == {:controller => "hats", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/hats/1/edit").should == {:controller => "hats", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/hats/1").should == {:controller => "hats", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/hats/1").should == {:controller => "hats", :action => "destroy", :id => "1"}
    end
  end
end
