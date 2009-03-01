#
# What you should see when you get there
#

  #
  # Destinations.  Ex:
  #   She should be at the new kids page
  #   Tarkin should be at the destroy alderaan page 
  #   The visitor should be at the '/lolcats/download' form
  #   The visitor should be redirected to '/hi/mom'
  #
  # It doesn't know anything about actual routes -- it just 
  # feeds its output to render_template or redirect_to
  #
  Then "$actor should be at $path" do |_, path|
    response.should render_template(template_from(path))
  end

  Then "$actor should be redirected to $path" do |_, path|
    response.should redirect_to(path_to(path))
  end  

  Then "the page should look AWESOME" do
    response.should have_tag('head>title')
    response.should have_tag('h1')
    # response.should be_valid_xhtml
  end
  
  #
  # Tags 
  #
  
  Then "the page should contain '$text'" do |_, text|
    response.should have_text(/#{text}/)
  end
  
  # please note: this enforces the use of a <label> field
  Then "$actor should see a <$container> containing a $attributes" do |_, container, attributes|
    attributes = attributes.to_hash_from_story
    response.should have_tag(container) do
      attributes.each do |tag, label|
        case tag
        when "textfield" then with_tag "input[type='text']";     with_tag("label", label)
        when "password"  then with_tag "input[type='password']"; with_tag("label", label)
        when "submit"    then with_tag "input[type='submit'][value='#{label}']"
        else with_tag tag, label
        end
      end
    end
  end

  #
  # Session, cookie variables
  #
  Then "$actor $token cookie should include $attrlist" do |_, token, attrlist|
    attrlist = attrlist.to_array_from_story
    cookies.include?(token).should be_true
    attrlist.each do |val|
      cookies[token].include?(val).should be_true
    end
  end
  
  Then "$actor $token cookie should exist but not include $attrlist" do |_, token, attrlist|
    attrlist = attrlist.to_array_from_story
    cookies.include?(token).should be_true
    puts [cookies, attrlist, token].to_yaml
    attrlist.each do |val|
      cookies[token].include?(val).should_not be_true
    end
  end

  Then "$actor should have $an $token cookie" do |_, _, token|
    cookies[token].should_not be_blank
  end
  Then "$actor should not have $an $token cookie" do |_, _, token|
    cookies[token].should be_blank
  end

  Given "$actor has $an cookie jar with $attributes" do |_, _, attributes|
    attributes = attributes.to_hash_from_story
    attributes.each do |attr, val|
      cookies[attr] = val
    end
  end
  Given "$actor session store has no $attrlist" do |_, attrlist|
    attrlist = attrlist.to_array_from_story
    attrlist.each do |attr|
      # Note that the comparison passes through 'to_s'
      session[attr.to_sym] = nil
    end
  end
  
  Then "$actor session store should have $attributes" do |_, attributes|
    attributes = attributes.to_hash_from_story
    attributes.each do |attr, val|
      # Note that the comparison passes through 'to_s'
      session[attr.to_sym].to_s.should eql(val)
    end
  end
  
  Then "$actor session store should not have $attrlist" do |_, attrlist|
    attrlist = attrlist.to_array_from_story
    attrlist.each do |attr|
      session[attr.to_sym].blank?.should be_true
    end
  end

  #
  # Flash messages
  #
  
  Then /\w+ should \s*see an? (\w+) \s*message '(.*)'/ do |notice, message|
#    begin
      response.should have_flash(notice, %r{#{message}})
#    rescue Exception => e
#      puts response.methods.sort - Object.methods
#      puts response.body
#      sleep 5
#      raise e
#    end
  end
  
  Then "$actor should not see $an $notice message '$message'" do |_, _, notice, message|
    response.should_not have_flash(notice, %r{#{message}})
  end
  
  Then "$actor should see no messages" do |_|
    ['error', 'warning', 'notice'].each do |notice|
      response.should_not have_flash(notice)
    end
  end

  RE_POLITENESS = /(?:please|sorry|thank(?:s| you))/i
  Then %r{we should be polite about it} do 
    response.should have_tag("div.error,div.notice", RE_POLITENESS)
  end
  Then %r{we should not even be polite about it} do 
    response.should_not have_tag("div.error,div.notice", RE_POLITENESS)
  end
  
  #
  # Resource's attributes
  # 
  # "Then page should have the $resource's $attributes" is in resource_steps
  
  # helpful debug step
  Then "we dump the response" do
    dump_response
  end  


def have_flash notice, *args
  have_tag("div.#{notice}", *args)
end

