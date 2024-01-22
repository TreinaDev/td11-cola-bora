class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show index my_projects]
  before_action :set_project, only: [:show]

  def index
    @projects = Project.all
  end

  def my_projects
    @projects = Project.where(user_id: current_user)
    render :index
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to project_path(@project), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :category)
  end
end
