class HomeController < ApplicationController
  
  def index
	if( @current_user ) then
		redirect_to( :controller => 'topics', :action => 'index' )
	else 
		redirect_to( :controller => 'hats', :action => 'index' )
	end
  end

end
