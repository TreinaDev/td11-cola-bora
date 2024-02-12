require 'rails_helper'

RSpec.describe MeetingParticipantMailer, type: :mailer do
  context '#notify_meeting_participant' do
    it 'envia email para os participantes' do
      leader = create :user, email: 'leader@email.com'
      project = create :project, user: leader
      author = create :user, cpf: '412.025.650-26', email: 'author@email.com'
      author_role = create :user_role, user: author, project:, role: :admin
      meeting = create(:meeting, project:, user_role: author_role)
      user = create :user, cpf: '556.887.660-69', email: 'user@email.com'
      user_role = create :user_role, user:, project:, role: :contributor
      create(:meeting_participant, user_role: author_role, meeting:)
      create(:meeting_participant, user_role:, meeting:)

      mail = MeetingParticipantMailer.with(participants: meeting.meeting_participants).notify_meeting_participants

      expect(mail.subject).to eq 'Convite para Reunião'
      expect(mail.from).to eq ['notifications@colabora.com']
      expect(mail.to).to eq [author.email, user.email]
    end

    it 'contém detalhes da reunião' do
      leader = create :user, email: 'leader@email.com'
      project = create :project, user: leader
      author = create :user, cpf: '412.025.650-26', email: 'author@email.com'
      author_role = create :user_role, user: author, project:, role: :admin
      meeting = create(:meeting, project:, user_role: author_role)
      user = create :user, cpf: '556.887.660-69', email: 'user@email.com'
      user_role = create :user_role, user:, project:, role: :contributor
      create(:meeting_participant, user_role: author_role, meeting:)
      create(:meeting_participant, user_role:, meeting:)

      mail = MeetingParticipantMailer.with(participants: meeting.meeting_participants).notify_meeting_participants

      expect(mail.body).to include 'Convite para Reunião'
      expect(mail.body).to include ''
      expect(mail.body).to include ''
    end
  end
end
