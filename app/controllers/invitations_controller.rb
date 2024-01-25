class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.project = Project.find(params[:project_id])

    if @invitation.save
      redirect_to project_portfoliorrr_profile_path(@invitation.project, invitation_params[:profile_id]),
                  notice: t('.success')
    else
      redirect_to project_portfoliorrr_profile_path(@invitation.project, invitation_params[:profile_id]),
                  notice: t('.pending_invitation')
    end
  end

  def cancel
    invitation = Invitation.find(params[:id])
    invitation.cancelled!

    redirect_to project_portfoliorrr_profile_path(invitation.project, invitation.profile_id), notice: 'Convite cancelado!'
  end

  private

  def invitation_params
    params.require(:invitation).permit(:profile_id, :expiration_days)
  end
end
