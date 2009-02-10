require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../spec_shared_model'

describe Topic do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :summary => "value for summary",
      :current_hat => "Blue"
    }
    @thoughts = [{
      :summary     => "thought 1",
      :detail => "more about thought 1",
      :hat_id      => 1,
    }, {
      :summary     => "thought 2",
      :detail => "more about thought 2",
      :hat_id      => 2,
    }]
  end

  it "should have a default current_hat = Red" do
    topic = Factory(:topic)
    topic.current_hat.should == 'Red'
  end
  it "should not require a current_thought id" do
    topic = Factory(:topic)
    topic.save!
  end
  it "should allow a current_thought id" do
    topic = Factory(:topic)
    thought = Factory(:thought)
    topic.current_thought= thought
    topic.save
    tid = topic.id
    topic = nil
    t2 = Topic.find(tid)
    t2.current_thought.should == thought
  end
  it "should cascade deletes through to the thoughts" do
    thought = Factory( :thought )
    topic = thought.topic
    tid = topic.id
    th2 = Factory(:thought, :topic => topic)
    topic.thoughts << th2
    topic.thoughts.count.should == 2
    topic.save!
    topic.destroy
    Thought.find(:all, :conditions => "topic_id = #{tid}" ).should == []
  end

  it "should create a new instance given valid attributes" do
    Topic.create!(@valid_attributes)
  end

  it "should have many thoughts" do
    t = Topic.new
    t.thoughts << Thought.new()
    t.thoughts << Thought.new()
  t.thoughts.size.should == 2
  end

  it "should belong to a user" do
    t = Topic.new
    u = User.new
    t.user = u
    t.user.should == u
  end

  it "should allow the adding of multiple thoughts" do
    topic  = Topic.new(@valid_attributes)

    th1 = Thought.new( @thoughts[0] )
    topic.thoughts << th1
    th1.topic_id.should equal( topic.id )

    th2 = Thought.new( @thoughts[1] )
    topic.thoughts << th2
    th2.topic_id.should equal( topic.id )

    topic.save!

    t2 = Topic.find( topic.id )
    found_thoughts = t2.thoughts
    found_thoughts.count.should equal( 2 )
    found_thoughts[0].id.should equal( th1.id )
    found_thoughts[1].id.should equal( th2.id )
  end
end
