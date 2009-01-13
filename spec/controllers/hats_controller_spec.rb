require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HatsController do

  def mock_hat(stubs={})
    @mock_hat ||= mock_model(Hat, stubs)
  end

  describe "telling users about the rules" do
  	it "should expose the rules to the view" do
		Hat.should_receive(:find).with(:all).and_return([mock_hat])
		get :rules
		assigns[:hats].should == [mock_hat]
	end
  end
  
  describe "responding to GET index" do

    it "should expose all hats as @hats" do
      Hat.should_receive(:find).with(:all).and_return([mock_hat])
      get :index
      assigns[:hats].should == [mock_hat]
    end

    describe "with mime type of xml" do
  
      it "should NOT render all hats as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        get :index
	response.should_not be_success
      end
    end
  end

  describe "responding to GET show" do

    it "should expose the requested hat as @hat" do
      Hat.should_receive(:find).with("37").and_return(mock_hat)
      get :show, :id => "37"
      assigns[:hat].should equal(mock_hat)
    end
    
    describe "with mime type of xml" do

      it "should render the requested hat as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Hat.should_receive(:find).with("37").and_return(mock_hat)
        mock_hat.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new hat as @hat" do
      Hat.should_receive(:new).and_return(mock_hat)
      get :new
      assigns[:hat].should equal(mock_hat)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested hat as @hat" do
      Hat.should_receive(:find).with("37").and_return(mock_hat)
      get :edit, :id => "37"
      assigns[:hat].should equal(mock_hat)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created hat as @hat" do
        Hat.should_receive(:new).with({'these' => 'params'}).and_return(mock_hat(:save => true))
        post :create, :hat => {:these => 'params'}
        assigns(:hat).should equal(mock_hat)
      end

      it "should redirect to the created hat" do
        Hat.stub!(:new).and_return(mock_hat(:save => true))
        post :create, :hat => {}
        response.should redirect_to(hat_url(mock_hat))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved hat as @hat" do
        Hat.stub!(:new).with({'these' => 'params'}).and_return(mock_hat(:save => false))
        post :create, :hat => {:these => 'params'}
        assigns(:hat).should equal(mock_hat)
      end

      it "should re-render the 'new' template" do
        Hat.stub!(:new).and_return(mock_hat(:save => false))
        post :create, :hat => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested hat" do
        Hat.should_receive(:find).with("37").and_return(mock_hat)
        mock_hat.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :hat => {:these => 'params'}
      end

      it "should expose the requested hat as @hat" do
        Hat.stub!(:find).and_return(mock_hat(:update_attributes => true))
        put :update, :id => "1"
        assigns(:hat).should equal(mock_hat)
      end

      it "should redirect to the hat" do
        Hat.stub!(:find).and_return(mock_hat(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(hat_url(mock_hat))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested hat" do
        Hat.should_receive(:find).with("37").and_return(mock_hat)
        mock_hat.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :hat => {:these => 'params'}
      end

      it "should expose the hat as @hat" do
        Hat.stub!(:find).and_return(mock_hat(:update_attributes => false))
        put :update, :id => "1"
        assigns(:hat).should equal(mock_hat)
      end

      it "should re-render the 'edit' template" do
        Hat.stub!(:find).and_return(mock_hat(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested hat" do
      Hat.should_receive(:find).with("37").and_return(mock_hat)
      mock_hat.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the hats list" do
      Hat.stub!(:find).and_return(mock_hat(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(hats_url)
    end

  end

end
