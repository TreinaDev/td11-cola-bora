class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show edit update]
  before_action :authorize_user, only: %i[edit update]

  def show
    @profile = current_user.profile
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    @profile.update(profile_params)
    redirect_to profile_path(@profile), notice: t('.success')
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :work_experience,
                                    :education)
  end

  def authorize_user
    redirect_to root_path unless current_user == Profile.find(params[:id]).user
  end
end
