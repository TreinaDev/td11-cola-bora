class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit destroy members]
  before_action :check_contributor, only: %i[show edit destroy members]

  def index
    @projects = Project.where(user_id: current_user)
  end

  def new
    @job_categories = JobCategory.all
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
    @project_job_categories = @project.project_job_categories
    @job_categories = JobCategory.fetch_job_categories_by_project(@project_job_categories)
  end

  def edit; end

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

  private

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

  def create_project
    @project = current_user.projects.build(title: project_params[:title],
                                           description: project_params[:description],
                                           category: project_params[:category])

    create_job_category(project_params[:project_job_category_ids])
  end
end
