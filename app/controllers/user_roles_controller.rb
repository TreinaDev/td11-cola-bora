class UserRolesController < ApplicationController
  before_action :set_project, only: %i[edit update]
  before_action :set_user_role, only: %i[edit update]

  def edit; end

  def update
    @user_role.admin!
    redirect_to members_project_path(@project), notice: t('.success')
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_user_role
    @user_role = UserRole.find(params[:id])
  end
end
