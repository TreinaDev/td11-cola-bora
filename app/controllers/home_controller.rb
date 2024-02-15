class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    redirect_to projects_path if user_signed_in?
  end
end
