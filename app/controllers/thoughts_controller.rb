class ThoughtsController < ApplicationController
  
  before_filter :load_topic
  
  protected
  
  def load_topic
    @topic = Topic.find(params[:topic_id])
  end
  
  public
  
  # GET /topics/:topic_id/thoughts
  # GET /topics/:topic_id/thoughts.xml
  def index
    @thoughts = @topic.thoughts
    
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
    @thought = @topic.thoughts.find(params[:id])
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
    @thought = @topic.thoughts.find(params[:id])

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
    @thought = @topic.thoughts.find(params[:id])
    @thought.destroy

    respond_to do |format|
      format.html { redirect_to(topic_path(@topic)) }
      format.xml  { head :ok }
    end
  end
end
