class ProfilesController < ApplicationController
  before_action :authorize_user, only: %i[edit update]
  before_action :set_profile, only: %i[show edit update]

  def show; end

  def edit; end

  def update
    @profile.update(profile_params)
    redirect_to profile_path(@profile), notice: t('.success')
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :work_experience,
                                    :education)
  end

  def authorize_user
    redirect_to root_path unless current_user == Profile.find(params[:id]).user
  end
end
