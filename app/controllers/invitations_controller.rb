class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)

    @invitation.save
    redirect_to portfoliorrr_profile_path(invitation_params[:profile_id]),
                notice: t('.success')
  end

  private

  def invitation_params
    params.require(:invitation).permit(:profile_id, :due_date, :project_id)
  end
end
