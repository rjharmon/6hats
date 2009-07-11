# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  filter_parameter_logging :password

  helper_method :current_user_session, :current_user

  private
    def logout
      @current_user_session = nil
      @current_user = nil
    end
    
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
   
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
   
    def require_user
      unless current_user
        store_location
        flash[:notice] = "Please log in to continue"
        redirect_to login_url( :next => request.request_uri )
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        # (:next => request.request_uri)
        return false
      end
    end
   
    def store_location
      session[:return_to] = request.request_uri
    end
   
    def redirect_back_or_default(default)
      redirect_to( params[:next] || session[:return_to] || default)
      session[:return_to] = nil
    end
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  def show_error(detail, redir_to, msg, level)
    logger.info( "Permission denied for user '#{current_user.login}': #{detail}" )
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
