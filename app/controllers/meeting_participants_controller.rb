class MeetingParticipantsController < ApplicationController
  before_action :set_meeting_and_project_and_contributors, only: %i[new create]
  def new
    @participants = MeetingParticipant.new
  end

  def create
    # @participants = []
    participants_params.each do |participant|
      @participants = @meeting.meeting_participants.create(user_role_id: participant)
    end
    redirect_to project_meeting_path(@project, @meeting)
    # end
    # if @participants.save_all
    #   redirect_to project_meeting_path(@project, @meeting)
    # end
  end

  private

  def set_meeting_and_project_and_contributors
    @project = Project.find(params[:project_id])
    @meeting = Meeting.find(params[:meeting_id])
    @contributors = @project.user_roles
  end

  def participants_params
    params.require(:meeting_participant).permit(meeting_participant_ids: [])
  end
end
