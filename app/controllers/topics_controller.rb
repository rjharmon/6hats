class TopicsController < ApplicationController
  before_filter :fetch_user

protected
	def fetch_user
		session[:userid] && @user = User.find( session[:userid] )
		if ! @user 
			flash[:notice] = "Please log in to continue"
			redirect_to login_url
		end
	end
public
  # GET /topics
  # GET /topics.xml
  def index

    debugger;
    @topics = @user.topics.find(:all)

    respond_to do |format|
      format.html do
      	 if @topics.size == 0
      	 	flash[:notice] = "You don't have any topics yet.  Create a new one here."
      	 	redirect_to new_topic_url
      	 end
      end
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = @user.topics.find(params[:id])
    @thoughts = @topic.thoughts

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic.to_xml( :include => :thoughts ) }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = @user.topics.build()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = @user.topics.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = @user.topics.build(params[:topic])

    respond_to do |format|
      if @topic.save
        flash[:notice] = 'Topic was successfully created.'
        format.html { redirect_to(@topic) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = @user.topics.find(params[:id])

    respond_to do |format|
      debugger
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = @user.topics.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
end
