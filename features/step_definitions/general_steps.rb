Given /I\'m logged in/ do   
#'
  Given 'a user: "me" exists with login: "myself"'
  @user = model 'user: "me"'
  pp @user
  activate_user!( @user.activation_code )
  Given 'I am logged in as user: "me"'
end

Given "I am logged in as #{capture_model}" do |user|
  u = model(user)
  log_in_user!( { :password => 'fake passwd', :login => u.login } )
end

Then /let me see the results/ do 
  save_and_open_page
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
 