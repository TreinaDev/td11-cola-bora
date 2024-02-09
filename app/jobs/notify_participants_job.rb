class NotifyParticipantsJob < ApplicationJob
  queue_as :default

  def perform(meeting)
    # if meeting.datetime&.past?
    return if meeting.datetime&.past?

    #return if meeting.datetime - NotifyParticipantsJob.scheduled_at > 5.minutes

    logger.info('Iniciando emfileramento que notifica reunião')
    participants = meeting.project.users

    participants.each do |participant|
      MeetingMailer.with(meeting:, participant:).notify_team_about_meeting.deliver
    end
    logger.info('Finalizando job que notifica reunião')
  end
end
