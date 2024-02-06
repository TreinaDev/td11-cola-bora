class CalendarsController < ApplicationController
  before_action :set_project, only: %i[index]

  def index
    @meetings = @project.meetings
    @tasks = @project.tasks

    if params[:filter].blank?
      @events = @meetings + @tasks
    elsif params[:filter] == 'meetings'
      @events = @meetings
    elsif params[:filter] == 'tasks'
      @events = @tasks
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
