class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || projects_path
  end
end
