class MeetingParticipantMailer < ApplicationMailer
  helper :meeting
  default from: 'notifications@colabora.com'

  def notify_meeting_participants
    @meeting_participants = params[:participants]
    @meeting = @meeting_participants.first.meeting
    emails = @meeting_participants.map(&:email)

    mail(to: emails, subject: t('.subject'))
  end
end
