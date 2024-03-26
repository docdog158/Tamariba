class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, if: :devise_controller?
  
  def after_sign_up_path_for(resource)
    root_path
  end
  
  def after_sign_out_path_for(resource)
    about_path
  end

  protected
  
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
