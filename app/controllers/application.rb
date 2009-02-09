# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'f3a8767f91ea790da536e96aa92eff67'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password


  def fetch_user
    if ! @user = current_user
      flash[:notice] = "Please log in to continue"
      redirect_to login_url 
      return false
    end
  end

  def show_error(detail, redir_to, msg, level)
    logger.info( "Permission denied for user '#{@user.login}': #{detail}" )
    respond_to do |format|
      format.html do
        flash[level] = msg + ": #{detail}";
        redirect_to redir_to
      end
      format.xml { render :xml => msg, :status => :unprocessable_entity }
    end
    return false
  end

  def gripe(detail, redir_to, msg = "Warning")
    show_error(detail,redir_to,msg,:notice)
  end

  def denied(detail, redir_to, msg = "Permission denied")
    show_error(detail,redir_to, msg,:warning)
  end
end
