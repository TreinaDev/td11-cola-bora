require 'rails_helper'

RSpec.describe NotifyParticipantsJob, type: :job do
  describe '#peform' do
    it 'verificca se o Job foi enfileirado com sucesso' do
      leader = create(:user)
      project = create(:project, user: leader)
      contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
      contributor_role = project.user_roles.create!(user: contributor)
      meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião sobre Caaptura de Pokémon')

      expect do
        NotifyParticipantsJob.perform_later(meeting)
      end.to have_enqueued_job
    end

    it 'verifica se cria o email' do
      leader = create(:user)
      project = create(:project, user: leader)
      contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
      contributor_role = project.user_roles.create!(user: contributor)
      meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião sobre Caaptura de Pokémon')

      mail = double('mail', deliver: true)
      mailer_double = double('MeetingMailer')

      allow(MeetingMailer).to receive(:with).and_return(mailer_double)
      allow(mailer_double).to receive(:notify_team_about_meeting).and_return(mail)

      NotifyParticipantsJob.perform_now(meeting)

      expect(mail).to have_received(:deliver).twice
    end
  end

  describe '#perform_later' do
    it 'Verifica agendamento de envio de e-mail' do
      leader = create(:user)
      project = create(:project, user: leader)
      contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
      contributor_role = project.user_roles.create!(user: contributor)
      meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião sobre Caaptura de Pokémon')

      expect do
        NotifyParticipantsJob.set(wait_until: meeting.datetime - 5.minutes).perform_later(meeting)
      end.to have_enqueued_job.with(meeting).at(meeting.datetime - 5.minutes)
    end
  end
end
