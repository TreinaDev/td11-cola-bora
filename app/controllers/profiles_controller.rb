class ProfilesController < ApplicationController
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
end
