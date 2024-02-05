class UserRolesController < ApplicationController
  before_action :set_user_role, only: %i[edit update remove]
  before_action :set_project, only: %i[edit update remove]
  before_action :redirect_if_role_is_leader, only: %i[edit update remove]
  before_action :authorize_leader, only: %i[edit update]

  def edit; end

  def update
    if sanitized_role && @user_role.update(role: sanitized_role)
      redirect_to members_project_path(@project), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def remove
    return redirect_to root_path, alert: t('.fail') unless @project.leader? current_user

    @user_role.update active: false
    redirect_to members_project_path(@project), notice: t('.success')
  end

  private

  def set_project
    @project = Project.find_by(id: params[:project_id]) || @user_role.project
  end

  def set_user_role
    @user_role = UserRole.find(params[:id])
  end

  def redirect_if_role_is_leader
    redirect_to root_path if @user_role.leader?
  end

  def authorize_leader
    redirect_to root_path, alert: t('.fail') unless @project.leader? current_user
  end

  def sanitized_role
    role = params[:user_role][:role]
    role if %w[admin contributor].include?(role)
  end
end
