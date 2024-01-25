class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)

    if @invitation.save
      redirect_to portfoliorrr_profile_path(invitation_params[:profile_id]),
                  notice: t('.success')
    else
      redirect_to portfoliorrr_profile_path(invitation_params[:profile_id]),
                  notice: t('.pending_invitation')
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:profile_id, :expiration_days, :project_id)
  end
end
