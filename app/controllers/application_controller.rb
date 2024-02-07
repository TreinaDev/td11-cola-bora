class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_beginning_of_week

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def set_beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf])
  end

  def not_found
    redirect_to root_path, alert: t('.not_found')
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || projects_path
  end
end
