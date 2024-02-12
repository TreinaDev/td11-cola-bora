class NotifyParticipantsJob < ApplicationJob
  queue_as :default

  def perform(meeting)
    return unless meeting_starts_soon?(meeting)

    logger.info('Iniciando enfileiramento que notifica reunião')
    participants = meeting.project.users

    participants.each do |participant|
      MeetingMailer.with(meeting:, participant:).notify_team_about_meeting.deliver
    end
    logger.info('Finalizando job que notifica reunião')
  end
end

def meeting_starts_soon?(meeting)
  (meeting.datetime - 5.minutes).strftime('%H:%M') == Time.zone.now.strftime('%H:%M')
end
