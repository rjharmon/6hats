require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../spec_shared_model'

describe Topic do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
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

  it "should create a new instance given valid attributes" do
    Topic.create!(@valid_attributes)
  end

  it_should_behave_like "Relationships"
  # TODO: it_has_one Topic.new.thoughts, Thought.new();
  
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
