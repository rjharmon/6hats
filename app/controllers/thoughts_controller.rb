class ThoughtsController < ApplicationController

  before_filter(:get_topic, :except => 'index')

  # GET /topics/:topic_id/thoughts/1
  # GET /topics/:topic_id/thoughts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @thought }
    end
  end

  # GET /topics/:topic_id/thoughts/new
  # GET /topics/:topic_id/thoughts/new.xml
  def new
    @thought = Thought.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @thought }
    end
  end

  # GET /topics/:topic_id/thoughts/1/edit
  def edit
  end

  # POST /topics/:topic_id/thoughts
  # POST /topics/:topic_id/thoughts.xml
  def create
    @thought = Thought.new(params[:thought])

    respond_to do |format|
      if @thought.save
        flash[:notice] = 'Thought was successfully created.'
        format.html { redirect_to(topic_thought_url(@topic,@thought)) }
        format.xml  { render :xml => @thought, :status => :created, :location => @thought }
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
        format.html { redirect_to(topic_thought_url(@topic,@thought)) }
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
      format.html { redirect_to(topic_thoughts_url(@topic)) }
      format.xml  { head :ok }
    end
  end

private
  def get_topic
	@topic = Topic.find(params[:topic_id])
	@thought = @topic.thoughts.find(params[:thought_id]) if params[:thought_id]
  rescue ActiveRecord::RecordNotFound
	flash[:notice] = "Invalid URL detected"
	redirect_to @topic || topics_url
  end

end
