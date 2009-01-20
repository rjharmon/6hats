class Hat < ActiveRecord::Base
# states available:
# * Fresh (creating a new topic)
#   * -> Explore Emotions (vent)
#   * -> Define the Problem
#   * User may also not be sure what the problem is -> Fact Finding
# * Define the problem
#   * -> Ideation (explore possibilities)
#   * -> Potential and Motivation (imagine what could be possible)
#   * -> Fact Finding (recognize truths/factual constraints)
# * Fact Finding
#   * -> Ideation (how can we use these facts)
#   * Note: this may be like blue hat - push and pop this state as an in-built 
#     part of the flow, instead of it being a step on a linear path
# * Ideation
#   * -> Potential & Motivation (what's good about this idea, where could it lead?)
#   * -> Problem Identification (what problems could arise with these ideas?)
#   * -> Explore Emotions (how do we feel about these ideas?)
# * Potential and Motivation
#   * -> Ideation (How could this potential actually be achieved?)
#   * -> Problem Identification (What problems can we identify and possibly work around?)
# * Problem Identification
#   * -> Potential & Motivation (What reasons would we have for finding a solution to these problems?)
#   * -> Ideation (What ideas do we have for solving these problems?)
#   * -> Explore Emotions (How do we feel about these problem?)
# * Explore Emotions
#   * not actually an endpoint, but no explicit next actions 
#   * use it prior to more objective steps (yellow/black) to increase objectivity
# * Solve the problem
#   * Recognize the thoughts already expressed which are the most salient to the objectives
end
