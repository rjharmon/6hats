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
end
