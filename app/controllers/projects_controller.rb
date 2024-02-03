class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy members]
  before_action :check_contributor, only: %i[show edit destroy members]
  before_action :check_leader, only: %i[edit update]
  before_action :set_all_job_categories, only: %i[new create edit update]
  before_action :set_project_job_categories, only: %i[show]

  def index
    @projects = Project.where(user_id: current_user)
  end

  def new
    @project = current_user.projects.build
  end

  def create
    create_project

    if @project.save
      redirect_to project_path(@project), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @job_categories = JobCategory.fetch_job_categories_by_project(@project_job_categories)
  end

  def edit; end

  def update
    update_project_job_categories

    if @project.update(project_params.except(:project_job_category_ids))
      redirect_to project_path(@project), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return redirect_to root_path, alert: t('.fail') unless current_user == @project.user

    @project.destroy
    redirect_to projects_path, notice: t('.success')
  end

  def members
    query = params[:query]

    @leader = @project.leader if query.blank? || query == 'leader'
    @admins = @project.admins if query.blank? || query == 'admin'
    @contributors = @project.contributors if query.blank? || query == 'contributor'
  end

  private

  def update_project_job_categories
    @project.project_job_categories.where.not(job_category_id: project_params[:project_job_category_ids]).destroy_all

    project_params[:project_job_category_ids]&.each do |category_id|
      @project.project_job_categories.find_or_create_by(job_category_id: category_id.to_i)
    end
  end

  def set_project_job_categories
    @project_job_categories = @project.project_job_categories
  end

  def set_all_job_categories
    @job_categories = JobCategory.all
  end

  def create_job_category(category_ids)
    category_ids&.each do |category_id|
      @project.project_job_categories.new(job_category_id: category_id.to_i)
    end
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :category,
                                    project_job_category_ids: [])
  end

  def check_contributor
    redirect_to root_path, alert: t('.not_contributor') unless @project.member?(current_user)
  end

  def check_leader
    redirect_to project_path(@project), alert: t('.not_leader') unless @project.leader?(current_user)
  end

  def create_project
    @project = current_user.projects.build(title: project_params[:title],
                                           description: project_params[:description],
                                           category: project_params[:category])

    create_job_category(project_params[:project_job_category_ids])
  end
end
