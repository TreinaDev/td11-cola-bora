class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show index edit update]
  before_action :set_project, only: %i[new create index show edit update]
  before_action :set_contributors, only: %i[new create edit update]
  before_action :set_task, only: %i[show edit update]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.build
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.author_id = current_user.id

    if @task.save
      redirect_to project_task_path(@project, @task), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to project_task_path(@project, @task), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_contributors
    # TODO
    # Limitar para os colaboradores do projeto
    @contributors = User.all
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :assigned_id)
  end
end
