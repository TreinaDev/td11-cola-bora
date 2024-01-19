class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_project, only: %i[new create]
  before_action :set_contributors, only: %i[new create]
  before_action :set_task, only: %i[show]

  def new
    @task = @project.tasks.build(author: current_user)
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
