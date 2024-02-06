class CalendarsController < ApplicationController
  before_action :set_project, only: %i[index]

  def index
    filter = params[:filter]
    @events = []
    @events += @project.meetings unless filter == 'tasks'
    @events += @project.tasks unless filter == 'meetings'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
