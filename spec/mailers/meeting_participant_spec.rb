require 'rails_helper'

RSpec.describe MeetingParticipantMailer, type: :mailer do
  context '#notify_meeting_participant' do
    it 'quando autor o adiciona a uma reunião' do
      mail = double('mail', deliver: true)
      mailer_double = double('MeetingPartcipantMailer', notify_meeting_participant: mail)

      allow(MeetingParticipantMailer).to receive(:with).and_return(mailer_double)
      allow(mailer_double).to receive(:notify_leader_finish_task).and_return(mail)

      expect(mail.subject).to eq ''
      expect(mail.to).to eq ''
    end
  end
end
