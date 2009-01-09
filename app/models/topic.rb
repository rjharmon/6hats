class Topic < ActiveRecord::Base
  has_many :thoughts;
end
