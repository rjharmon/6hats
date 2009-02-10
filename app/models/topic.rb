class Topic < ActiveRecord::Base
  has_many :thoughts, :dependent => :destroy;
  belongs_to :user;

  # we're pointing to one thought that's current.
  # the belongs-to syntax is not really representative of what's going on here.
  belongs_to :current_thought, :class_name => "Thought"

  validates_length_of :name, :minimum => 3
end
