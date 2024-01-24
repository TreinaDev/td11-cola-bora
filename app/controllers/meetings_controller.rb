class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[index new create]
  before_action :set_meeting, only: %i[show]

  def index
    @meetings = @project.meetings.order(datetime: :asc).where('datetime > ?', Date.current)
  end

  def new
    @meeting = @project.meetings.new
  end

  def create
    @meeting = @project.meetings.build(meeting_params)
    user_role = UserRole.find_by(user: current_user, project: @project)
    @meeting.user_role = user_role

    if @meeting.save
      redirect_to @meeting, notice: t('.success')
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

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :description, :datetime, :duration, :address)
  end
end
