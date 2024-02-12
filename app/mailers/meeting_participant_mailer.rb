class MeetingParticipantMailer < ApplicationMailer
  default from: 'notifications@colabora.com'

  def notify_meeting_participants
    @meeting_participants = params[:participants]
    emails = @meeting_participants.map(&:email)

    mail(to: emails, subject: 'Convite para Reunião')
  end
end
