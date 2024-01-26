class InvitationsController < ApplicationController
  before_action :authenticate_user!, only: %i[create cancel]
  before_action :create_invitation, only: %i[create]
  before_action :set_invitation, only: %i[cancel]
  before_action :authorize_user, only: %i[create cancel]
  before_action :authorize_cancel, only: %i[cancel]

  def create
    if @invitation.save
      return redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id),
                         notice: t('.success')
    end
    redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id),
                alert: t('.pending_invitation')
  end

  def cancel
    @invitation.cancelled!

    redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id), notice: t('.success')
  end

  private

  def invitation_params
    params.require(:invitation).permit(:expiration_days)
  end

  def create_invitation
    @invitation = Invitation.new(invitation_params)
    @invitation.project = Project.find(params[:project_id])
    @invitation.profile_id = params[:portfoliorrr_profile_id]
  end

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def authorize_user
    redirect_to root_path unless current_user == @invitation.project.user
  end

  def authorize_cancel
    redirect_to root_path unless @invitation.pending?
  end
end
