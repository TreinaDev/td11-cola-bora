require 'rails_helper'

RSpec.describe MeetingParticipantMailer, type: :mailer do
  include MeetingHelper
  context '#notify_meeting_participants' do
    it 'envia email para os participantes' do
      leader = create :user, email: 'leader@email.com'
      project = create :project, user: leader, title: 'Projeto Top'
      author = create :user, cpf: '412.025.650-26', email: 'author@email.com'
      author_role = create :user_role, user: author, project:, role: :admin
      meeting = create :meeting, project:, user_role: author_role
      participant = create :user, cpf: '556.887.660-69', email: 'participant@email.com'
      participant_role = create :user_role, user: participant, project:, role: :contributor
      meeting_participant = create :meeting_participant, meeting:, user_role: participant_role

      mail = MeetingParticipantMailer.with(participant: meeting_participant).notify_meeting_participants

      expect(mail.subject).to eq 'Convite para Reunião - Projeto Top'
      expect(mail.from).to eq ['notifications@colabora.com']
      expect(mail.to).to eq [participant.email]
      expect(mail.to).not_to include leader.email
      expect(mail.to).not_to include author.email
    end

    context 'contém detalhes da reunião' do
      it 'quando não é o autor' do
        leader = create :user, email: 'leader@email.com'
        project = create :project, user: leader, title: 'Projeto Top'
        author = create :user, cpf: '412.025.650-26', email: 'author@email.com'
        author_role = create :user_role, user: author, project:, role: :admin
        meeting = create :meeting, project:, user_role: author_role
        participant = create :user, cpf: '556.887.660-69', email: 'participant@email.com'
        participant_role = create :user_role, user: participant, project:, role: :contributor
        meeting_participant = create :meeting_participant, meeting:, user_role: participant_role

        mail = MeetingParticipantMailer.with(participant: meeting_participant).notify_meeting_participants

        expect(mail.body).to include 'Convite para Reunião - Projeto Top'
        expect(mail.body).to include "#{author.full_name} está te convidando para uma reunião:"
        expect(mail.body).to include "Endereço: #{link_to_address meeting.address}"
        expect(mail.body).to include "Data e horário: #{meeting.datetime.strftime('%d/%m/%Y, %H:%M')}"
        expect(mail.body).to include "Duração: #{format_duration meeting.duration}"
        expect(mail.body).to include 'Para mais detalhes, clique'
        expect(mail.body).to include 'aqui'
      end

      it 'quando é o autor' do
        leader = create :user, email: 'leader@email.com'
        project = create :project, user: leader, title: 'Projeto Top'
        author = create :user, cpf: '412.025.650-26', email: 'author@email.com'
        author_role = create :user_role, user: author, project:, role: :admin
        meeting = create :meeting, project:, user_role: author_role
        meeting_participant = create :meeting_participant, meeting:, user_role: author_role

        mail = MeetingParticipantMailer.with(participant: meeting_participant).notify_meeting_participants

        expect(mail.body).to include 'Convite para Reunião - Projeto Top'
        expect(mail.body).to include 'Você tem uma nova reunião:'
        expect(mail.body).to include "Endereço: #{link_to_address meeting.address}"
        expect(mail.body).to include "Data e horário: #{meeting.datetime.strftime('%d/%m/%Y, %H:%M')}"
        expect(mail.body).to include "Duração: #{format_duration meeting.duration}"
        expect(mail.body).to include 'Para mais detalhes, clique'
        expect(mail.body).to include 'aqui'
      end
    end
  end
end
