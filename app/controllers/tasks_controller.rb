class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: %i[show edit update start finish cancel]
  before_action :check_contributor
  before_action :can_edit_task?, only: %i[edit update]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.build(task_params)
    user_role = UserRole.find_by(user: current_user, project: @project)
    @task.user_role = user_role

    if @task.save
      redirect_to [@project, @task], notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to [@project, @task], notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def start
    @task.in_progress!
    redirect_to project_task_path(@project), notice: t('.success')
  end

  def finish
    @task.finished!
    redirect_to project_task_path(@project), notice: t('.success')
  end

  def cancel
    @task.cancelled!
    redirect_to project_task_path(@project), notice: t('.success')
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :assigned_id)
  end

  def check_contributor
    redirect_to root_path, alert: t('.not_contributor') unless @project.member?(current_user)
  end

  def can_edit_task?
    redirect_to project_task_path(@project, @task), alert: t('.fail') unless current_user.can_edit?(@task)
  end
end
