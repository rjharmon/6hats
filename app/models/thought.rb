# == Schema Information
# Schema version: 20090209051856
#
# Table name: thoughts
#
#  id         :integer         not null, primary key
#  topic_id   :integer
#  summary    :string(255)
#  detail     :text
#  hat_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Thought < ActiveRecord::Base
  belongs_to :topic
  belongs_to :hat, :foreign_key => :hat
  validates_length_of :summary, :minimum => 3
  
  


# Target thoughts to automatically create:
# * Ideation
#   * H -> Potential & Motivation (what's good about this idea, where could it lead?)
#   * M -> Problem Identification (what problems could arise with these ideas?)
#   * L -> Explore Emotions (how do we feel about these ideas?)
# * Potential and Motivation
#   * M -> Ideation (How could this potential actually be achieved?)
#   * H -> Problem Identification (What problems can we identify and possibly work around?)
#   * H -> Emotions (Intuition on which ones will be strong contenders)
# * Problem Identification
#   * H -> Potential & Motivation (What reasons would we have for finding a solution to these problems?)
#   * H -> Facts and information needed
#   * M -> Ideation (What ideas do we have for solving these problems?)
#   * L -> Explore Emotions (How do we feel about these problem?)
# * Explore Emotions
#   * not actually an endpoint, but no explicit next actions 
#   * use it prior to more objective steps (yellow/black) to increase objectivity
# * Solve the problem
#   * Recognize the thoughts already expressed which are the most salient to the objectives


end


