# == Schema Information
# Schema version: 20090209051856
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  login               :string(255)     not null
#  name                :string(100)     default("")
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  activated_at        :datetime
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'digest/sha1'

class User < ActiveRecord::Base
  attr_accessible :login, :email, :name, :password, :password_confirmation, :persistence_token

  validates_presence_of :name
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    if ENV["RSPEC"]
      c.maintain_sessions = false
    end
  end
  
  has_many :topics
  def recently_activated?
    @recently_activated
  end
  def activate
    @recently_activated = true
  end
end

