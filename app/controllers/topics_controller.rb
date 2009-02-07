class TopicsController < ApplicationController
  before_filter :fetch_user
  before_filter :fetch_topic, :except => [ :new, :create ]
  before_filter :check_userid,  :only => [ :create, :update ]
  
protected
    
  def fetch_topic
    if params[:id]
      @topic = @user.topics.find_by_id(params[:id])
      if ! @topic 
        return denied( "user doesn't have that topic id", topics_url )
      end
    else
      @topics = @user.topics.find(:all)
    end
  end
  def check_userid
    if params[:topic] && u = params[:topic][:user_id]
      unless u == current_user.id
        denied( "User can't post to that topic ID", topics_url )
        return false
      end
    end
  end
public
  # GET /topics
  # GET /topics.xml
  def index

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
    @thoughts = @topic.thoughts if @topic

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

    respond_to do |format|
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
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
end
