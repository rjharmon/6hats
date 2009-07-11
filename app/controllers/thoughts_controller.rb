class ThoughtsController < ApplicationController
  before_filter :require_user
  before_filter :fetch_topic
  before_filter :fetch_thought, :except => [ :new, :create ]
#  before_filter :check_topic_id, :only => [ :create, :update ]

protected
  
  def fetch_topic
    if params[:topic_id]
      @topic = current_user.topics.find_by_id(params[:topic_id])
    end
    if ! @topic
      if current_user
        return denied( "user doesn't have that topic id", topics_url )
      else
        return denied( "You must be logged in", login_url )
      end
    end
  end
  
  def fetch_thought
    if params[:id]
      @thought = @topic.thoughts.find_by_id(params[:id])
      if ! @thought 
        return gripe( "No such thought for that topic", topic_url( @topic ) )
      end
    else
      @thoughts = @topic.thoughts.find(:all)
    end
  end
  
  
public
  
  # GET /topics/:topic_id/thoughts
  # GET /topics/:topic_id/thoughts.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @thoughts }
    end
  end

  # GET /topics/:topic_id/thoughts/new
  # GET /topics/:topic_id/thoughts/new.xml
  def new
    @thought = @topic.thoughts.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @thought }
    end
  end

  # GET /topics/:topic_id/thoughts/edit
  def edit
    # done by before_filter
    # @thought = @topic.thoughts.find(params[:id])
  end

  # POST /topics/:topic_id/thoughts
  # POST /topics/:topic_id/thoughts.xml
  def create
    @thought = @topic.thoughts.build(params[:thought])
    
    respond_to do |format|
      if @thought.save
        flash[:notice] = 'Thought was successfully created.'
        format.html { redirect_to(@topic) }
        format.xml  { render :xml => @thought, :status => :created, :location => topic_path(topic, @thought) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @thought.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/:topic_id/thoughts/1
  # PUT /topics/:topic_id/thoughts/1.xml
  def update
    respond_to do |format|
      if @thought.update_attributes(params[:thought])
        flash[:notice] = 'Thought was successfully updated.'
        format.html { redirect_to(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @thought.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/:topic_id/thoughts/1
  # DELETE /topics/:topic_id/thoughts/1.xml
  def destroy
    @thought.destroy

    respond_to do |format|
      format.html { redirect_to(topic_path(@topic)) }
      format.xml  { head :ok }
    end
  end
end
