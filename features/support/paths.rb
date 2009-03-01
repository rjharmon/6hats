
RE_PRETTY_RESOURCE = /the (index|show|new|create|edit|update|destroy) (\w+) (page|form)/i
RE_THE_FOO_PAGE    = /the '?([^']*)'? (template|form)/i
RE_QUOTED_PATH     = /^'([^']*)'$/i
RE_ABSOLUTE_PATH   = /^(\/.*)$/i

def template_from(page_name)
  path = path_to(page_name)
  options = ActionController::Routing::Routes.recognize_path(path, :method => :get)
  template = options[:controller] + '/' + options[:action]
rescue Exception => e
  case page_name
  when RE_PRETTY_RESOURCE
    template_for $1, $2
  when RE_THE_FOO_PAGE
    $1
  else 
    raise "Can't match template for page #{page_name}"
  end  
end

def template_for(action, resource)
   "#{resource.gsub(" ","_")}/#{action}"
end

def path_to(page_name)
  case page_name
  
  when /the home ?page/i
    root_path
    
  when RE_QUOTED_PATH 
    $1

  when RE_ABSOLUTE_PATH
    $1
    
    # added by script/generate pickle path

    when /^#{capture_model}(?:'s)? page$/                           # eg. the forum's page
      path_to_pickle $1

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's post's page
      path_to_pickle $1, $2

    when /^#{capture_model}(?:'s)? #{capture_model}'s (.+?) page$/  # eg. the forum's post's comments page
      path_to_pickle $1, $2, :extra => $3                           #  or the forum's post's edit page

    when /^#{capture_model}(?:'s)? (.+?) page$/                     # eg. the forum's posts page
      path_to_pickle $1, :extra => $2                               #  or the forum's edit page

    when /^the (.+?) page$/                                         # translate to named route
      send "#{$1.downcase.gsub(' ','_')}_path"
  
    # end added by pickle path

  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end


