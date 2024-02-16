class MeetingParticipantMailer < ApplicationMailer
  helper :meeting
  default from: 'notifications@colabora.com'

  def notify_meeting_participants
    participant = params[:participant]
    @meeting = participant.meeting

    @is_author = participant.user_role == @meeting.user_role

    mail(to: participant.email, subject: t('.subject', title: @meeting.project.title))
  end
end
