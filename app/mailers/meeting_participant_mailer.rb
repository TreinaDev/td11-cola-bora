class MeetingParticipantMailer < ApplicationMailer
  default from: 'notifications@colabora.com'

  def notify_meeting_participant
    @meeting = params[:meeting]
    @project = @meeting.project
    @meeting_participants = @meeting.meeting_participants
    mail(to: @leader.email, subject: t('.subject'))
  end
end
