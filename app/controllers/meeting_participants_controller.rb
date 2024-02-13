class MeetingParticipantsController < ApplicationController
  before_action :set_meeting, only: %i[new create]
  before_action :set_project, only: %i[new create]
  before_action :set_contributors, only: %i[new create]
  before_action :set_new_meeting_participant, only: %i[new create]
  before_action :check_authorization, only: %i[new create]

  def new; end

  def create
    return unless check_number_of_participants.nil?

    participants = build_participants

    if participants.all?(&:valid?)
      participants.each(&:save)
      send_emails(participants)
      redirect_to project_meeting_path(@meeting.project, @meeting), notice: t('.success')
    else
      flash.now[:alert] = t '.fail'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:meeting_id])
  end

  def set_project
    @project = @meeting.project
  end

  def set_contributors
    @contributors = @meeting.project.user_roles
  end

  def set_new_meeting_participant
    @participant = MeetingParticipant.new
  end

  def check_number_of_participants
    return if participants_params&.count&.>= 2

    flash.now[:alert] = t '.check_number_of_participants'
    render :new, status: :unprocessable_entity
  end

  def participants_params
    return unless params[:meeting_participant]

    params.require(:meeting_participant).permit(meeting_participant_ids: [])[:meeting_participant_ids]
  end

  def check_authorization
    redirect_to root_path, alert: t('unauthorized') unless current_user == @meeting.user
  end

  def build_participants
    participants_params.map do |participant|
      @meeting.meeting_participants.build(user_role_id: participant)
    end
  end

  def send_emails(participants)
    participants.each do |participant|
      MeetingParticipantMailer.with(participant:).notify_meeting_participants.deliver
    end
  end
end
