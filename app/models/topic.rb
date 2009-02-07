class Topic < ActiveRecord::Base
  has_many :thoughts;
  belongs_to :user;
  validates_length_of :name, :minimum => 3
  validates_length_of :summary, :minimum => 3
end
