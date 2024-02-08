class NotifyParticipantsJob < ApplicationJob
  queue_as :default

  def perform(meeting)
    participants = meeting.project.users

    participants.each do |participant|
      MeetingMailer.with(meeting:, participant:).notify_team_about_meeting.deliver
    end
  end
end
