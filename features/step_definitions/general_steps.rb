Given /I\'m logged in/ do   
#'
#  debugger
# Given 'a user: "me" exists with login: "myself"'
  Given "an activated user named 'myself'"
  Then 'user: "me" should exist with login: "myself"'
  @user = model 'user: "me"'
  Given 'I am logged in as user: "me"'
end

Given "I am logged in as #{capture_model}" do |user|
  log_in_user!( { :password => 'fake passwd', :login => @user.login } )
end

Given "I have no topics" do 
  @user.topics.size.should == 0
end

Then /let me see the results/ do 
  save_and_open_page
end

Then /it should send (\d+) email[s]?/ do |count|
    ActionMailer::Base.deliveries.length.should == count.to_i
end

Then /^\w+ should get an email with \w+ activation code$/ do
  email = ActionMailer::Base.deliveries[0]
  email.body.should =~ Regexp.new( @user.activation_code )
end

 def activate_user activation_code=nil
   activation_code = @user.activation_code if activation_code.nil?
   get "/activate/#{activation_code}"
 end

 def activate_user! *args
   activate_user *args
   response.should redirect_to('/login')
   follow_redirect!
   response.should have_flash("notice", /Signup complete!/)
 end
 