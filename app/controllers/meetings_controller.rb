class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_meeting, only: %i[show edit update]
  before_action :check_contributor
  before_action :can_edit_meeting?, only: %i[edit update]

  def index
    @meetings = @project.future_meetings
  end

  def new
    @meeting = @project.meetings.new
  end

  def create
    @meeting = @project.meetings.build(meeting_params)
    user_role = UserRole.find_by(user: current_user, project: @project)
    @meeting.user_role = user_role

    if @meeting.save
      redirect_to [@project, @meeting], notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @meeting.update(meeting_params)
      redirect_to [@project, @meeting], notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :description, :datetime, :duration, :address)
  end

  def check_contributor
    redirect_to root_path, alert: t('.not_contributor') unless @project.member?(current_user)
  end

  def can_edit_meeting?
    redirect_to project_meeting_path(@project, @meeting), alert: t('.fail') unless current_user.can_edit?(@meeting)
  end
end
