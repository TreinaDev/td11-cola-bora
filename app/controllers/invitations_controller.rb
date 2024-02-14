class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[cancel show accept decline]
  before_action :set_project, only: %i[create cancel accept decline]
  before_action :authorize_leader, only: %i[create cancel]
  before_action :authorize_invited, only: %i[show accept decline]

  def index
    @invitations = Invitation.where(profile_email: current_user.email).pending
  end

  def show
    @invitation.validate_expiration_days
  end

  def create
    create_invitation

    if @invitation.save
      PostInvitationJob.perform_later @invitation
      flash[:notice] = t('.process')
    else
      flash[:alert] = invitation_error
    end
    redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id)
  end

  def cancel
    @invitation.processing!
    if @invitation.cancelled!
      send_new_status_to_portfoliorrr
      redirect_to project_portfoliorrr_profile_path(@invitation.project, @invitation.profile_id), notice: t('.success')
    else
      @invitation.pending!
      redirect_to root_path, alert: t('.fail')
    end
  end

  def accept
    if @invitation.accepted!
      send_new_status_to_portfoliorrr
      @project.user_roles.create(user: User.find_by(email: @invitation.profile_email))
      redirect_to project_path(@project), notice: t('.success')
    else
      redirect_to root_path, alert: t('.fail')
    end
  end

  def decline
    if @invitation.declined!
      send_new_status_to_portfoliorrr
      redirect_to invitations_path, notice: t('.success')
    else
      redirect_to root_path, alert: t('.fail')
    end
  end

  private

  def send_new_status_to_portfoliorrr
    InvitationService::PortfoliorrrPatch.send(@invitation, @invitation.status)
  end

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

  def authorize_leader
    redirect_to root_path unless @project.leader?(current_user)
  end

  def authorize_invited
    redirect_to root_path unless @invitation.profile_email == current_user.email
  end

  def invitation_error
    return t('.fail') if @invitation.expiration_days&.negative?
    return t('.already_member') if @invitation.project.member?(@invitation.invitation_user)

    t('.pending_invitation')
  end
end
