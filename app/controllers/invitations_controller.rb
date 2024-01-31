class InvitationsController < ApplicationController
  before_action :authenticate_user!, only: %i[create cancel]
  before_action :set_invitation, only: %i[cancel]
  before_action :set_project, only: %i[create cancel]
  before_action :authorize_user, only: %i[create cancel]
  before_action :authorize_cancel, only: %i[cancel]

  def create
    create_invitation
    if @invitation.save
      return redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id),
                         notice: t('.success')
    end

    redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id),
                alert: invitation_error
  end

  def cancel
    @invitation.cancelled!

    redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id), notice: t('.success')
  end

  private

  def invitation_params
    params.require(:invitation).permit(:expiration_days, :message, :profile_email)
  end

  def create_invitation
    @invitation = Invitation.new(invitation_params)
    @invitation.project = Project.find(params[:project_id])
    @invitation.profile_id = params[:portfoliorrr_profile_id]
  end

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def set_project
    @project = if params[:project_id]
                 Project.find(params[:project_id])
               else
                 @invitation.project
               end
  end

  def authorize_user
    redirect_to root_path unless @project.leader?(current_user)
  end

  def authorize_cancel
    redirect_to root_path unless @invitation.pending?
  end

  def invitation_error
    return t('.fail') if @invitation.expiration_days&.negative?

    t('.pending_invitation')
  end
end
