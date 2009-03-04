# == Schema Information
# Schema version: 20090209051856
#
# Table name: topics
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  summary            :text
#  user_id            :integer
#  current_hat        :string(255)     default("Red")
#  current_thought_id :integer
#

class Topic < ActiveRecord::Base
  has_many :thoughts, :dependent => :destroy;
  belongs_to :user;

  # we're pointing to one thought that's current.
  # the belongs-to syntax is not really representative of what's going on here.
  belongs_to :current_thought, :class_name => "Thought"

  validates_length_of :name, :minimum => 3

  def state
    if self.new_record?
      "Fresh"
    elsif self.summary.length == 0
      if current_hat == "Red"
        "Explore Emotions"
      else
        "Define the Problem"
      end
    else
      current_hat
    end
  end
  
  def next_state
    if self.new_record?
      "Explore Emotions"
    elsif self.summary.length == 0
      "Define the Problem"
    else
      "figure out which hat is next" 
    end
  end
  
      
end
