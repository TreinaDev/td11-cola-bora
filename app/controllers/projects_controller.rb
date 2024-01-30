class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit destroy]
  before_action :check_contributor, only: %i[show edit destroy]
  before_action :set_project_job_categories, only: %i[show]

  def index
    @projects = Project.where(user_id: current_user)
  end

  def new
    @project_job_categories = ProjectJobCategory.all
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

  def edit; end

  def destroy
    return redirect_to root_path, alert: t('.fail') unless current_user == @project.user

    @project.destroy
    redirect_to projects_path, notice: t('.success')
  end

  private

  def set_project_job_categories
    @project_job_categories = @project.project_job_categories
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :category, job_categories_attributes: %i[name _destroy])
  end

  def check_contributor
    redirect_to root_path, alert: t('.not_contributor') unless @project.member?(current_user)
  end
end
