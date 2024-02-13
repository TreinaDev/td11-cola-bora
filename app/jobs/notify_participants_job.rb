class NotifyParticipantsJob < ApplicationJob
  queue_as :default

  def perform(meeting)
    return unless meeting.starts_soon?(meeting)

    logger.info('Iniciando enfileiramento que notifica reunião')
    participants = meeting.meeting_participants

    participants.each do |participant|
      MeetingMailer.with(meeting:, participant: participant.user).notify_team_about_meeting.deliver
    end
    logger.info('Finalizando job que notifica reunião')
  end
end
