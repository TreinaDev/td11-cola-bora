class ProfilesController < ApplicationController
  def show; end

  def edit
    @profile = current_user.profile
  end
end
