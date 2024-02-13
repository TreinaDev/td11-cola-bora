class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy members invitations]
  before_action :check_contributor, only: %i[show edit update destroy members]
  before_action :check_leader, only: %i[edit update]
  before_action :set_all_job_categories, only: %i[new create edit update]
  before_action :set_project_job_categories, only: %i[show edit]

  def index
    return @projects = current_user.contributing_projects if params[:filter] == 'contributing_projects'
    return @projects = current_user.my_projects if params[:filter] == 'my_projects'

    @projects = current_user.all_projects
  end

  def new
    @project = current_user.projects.build
  end

  def create
    create_project

    if @project.save
      redirect_to project_path(@project), notice: t('.success')
    else
      set_project_job_categories
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @job_categories = JobCategory.fetch_job_categories_by_project(@project_job_categories)
  end

  def edit; end

  def update
    if @project.update(project_params.except(:project_job_category_ids))
      update_project_job_categories
      redirect_to project_path(@project), notice: t('.success')
    else
      set_update_project_job_categories
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

    @leader = @project.member_roles(:leader).first.user if query.blank? || query == 'leader'
    @admins = @project.member_roles(:admin) if query.blank? || query == 'admin'
    @contributors = @project.member_roles(:contributor) if query.blank? || query == 'contributor'
  end

  def invitations
    @invitations = @project.invitations.order(:updated_at)
  end

  private

  def update_project_job_categories
    @project.project_job_categories.where.not(job_category_id: project_params[:project_job_category_ids]).destroy_all

    project_params[:project_job_category_ids]&.each do |category_id|
      @project.project_job_categories.find_or_create_by(job_category_id: category_id.to_i)
    end
  end

  def set_update_project_job_categories
    @project_job_categories = []
    project_params[:project_job_category_ids]&.each do |category_id|
      @project_job_categories << ProjectJobCategory.new(job_category_id: category_id.to_i)
    end
  end

  def set_project_job_categories
    @project_job_categories = @project.project_job_categories
  end

  def set_all_job_categories
    @job_categories = JobCategory.all
  end

  def set_project
    @project = Project.find_by(id: params[:id]) || Project.find_by(id: params[:project_id])
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

  def create_job_category(category_ids)
    category_ids&.each do |category_id|
      @project.project_job_categories.new(job_category_id: category_id.to_i)
    end
  end
end
