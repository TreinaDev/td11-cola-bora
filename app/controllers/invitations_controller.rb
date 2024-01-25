class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[create]

  def create
    if @invitation.save
      return redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id),
                         notice: t('.success')
    end
    redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id),
                notice: t('.pending_invitation')
  end

  def cancel
    invitation = Invitation.find(params[:id])
    invitation.cancelled!

    redirect_to project_portfoliorrr_profile_path(invitation.project, invitation.profile_id), notice: t('.success')
  end

  private

  def invitation_params
    params.require(:invitation).permit(:expiration_days)
  end

  def set_invitation
    @invitation = Invitation.new(invitation_params)
    @invitation.project = Project.find(params[:project_id])
    @invitation.profile_id = params[:portfoliorrr_profile_id]
  end
end
