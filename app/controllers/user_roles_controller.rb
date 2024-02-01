class UserRolesController < ApplicationController
  before_action :set_project, only: %i[edit update]
  before_action :set_user_role, only: %i[edit update]

  def edit; end

  def update
    return redirect_to root_path, alert: t('.fail') unless @project.leader? current_user

    if sanitized_role && @user_role.update(role: sanitized_role)
      redirect_to members_project_path(@project), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_user_role
    @user_role = UserRole.find(params[:id])
    return redirect_to root_path if @user_role.leader?

    @user_role
  end

  def sanitized_role
    role = params[:user_role][:role]
    role if %w[admin contributor].include?(role)
  end
end
