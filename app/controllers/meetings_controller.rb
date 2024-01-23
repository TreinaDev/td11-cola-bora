class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[index new create]

  def index
    @meetings = @project.meetings
  end

  def new
    @meeting = @project.meetings.new 
  end

  def create
    @meeting = @project.meetings.build(meeting_params)
    @meeting.user_role = set_user_role

    if @meeting.save
      redirect_to meeting_path(@meeting), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
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

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :description, :date, :time, :duration, :address)
  end

  def set_user_role
    (current_user.user_roles & @project.user_roles).first
  end
end

# project.user_roles