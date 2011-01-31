# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleBasedAuthorization
  # include ExceptionNotifiable  
  
  # checks for mobile version
  before_filter  :prepare_for_mobile
  # checks for login && autorization
  before_filter :login_required
  
  helper :all # include all helpers, all the time
  
  # Role.root has no restrictions
  permit :actions => :all, :to => Role['root']
   
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9ecc84b2e14edd366f676e9f179edf92'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  def access_denied
     respond_to do |format|
       format.any do 
         flash[:notice] = 'Access denied!'
         redirect_to new_session_path
       end
     end
   end
  
  def mobile_device?
    if session[:mobile_param]
        session[:mobile_param] == "1"
      else
        request.user_agent =~ /Mobile|webOS/
      end
  end
  helper_method :mobile_device?
  
  
   def prepare_for_mobile
     session[:mobile_param] = params[:mobile] if params[:mobile]
     request.format = :mobile if mobile_device?
   end
  
end
