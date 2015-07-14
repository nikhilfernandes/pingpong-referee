class SessionsController < Devise::SessionsController
  skip_before_filter :authenticate_referee!, :only => [:create]

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    return sign_in_and_redirect(resource_name, resource)
  end 

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope    
    sign_in(scope, resource) unless warden.user(scope) == resource
    render :json=> {:success=>true, :email=>resource.email}    
  end
 
  def failure
    render :json=> {:success=>false, :message=>"Username or password was incorrect."}, :status=>401    
  end

  
  

end