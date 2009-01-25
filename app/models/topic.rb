class Topic < ActiveRecord::Base
  has_many :thoughts;
  belongs_to :user;
end
