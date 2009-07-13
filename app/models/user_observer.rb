class UserObserver < ActiveRecord::Observer
  def after_create(user)
   # UserMailer.deliver_signup_notification(user) unless ENV["RSPEC"] or RAILS_ENV == "test"
  end

  def after_save(user)
  #  UserMailer.deliver_activation(user) if user.recently_activated?
  end
end
