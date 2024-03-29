require 'rails_helper'

RSpec.describe NotifyParticipantsJob, type: :job do
  describe '#perform' do
    it 'verifica se cria o email' do
      leader = create(:user)
      project = create(:project, user: leader)
      contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
      contributor_role = project.user_roles.create!(user: contributor)
      meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião sobre Caaptura de Pokémon',
                                 datetime: 0.days.from_now + 5.minutes)
      create(:meeting_participant, user_role: contributor_role, meeting:)

      mail = double('mail', deliver: true)
      mailer_double = double('MeetingMailer')

      allow(MeetingMailer).to receive(:with).and_return(mailer_double)
      allow(mailer_double).to receive(:notify_team_about_meeting).and_return(mail)

      NotifyParticipantsJob.perform_now(meeting)

      expect(mail).to have_received(:deliver).once
    end
  end

  describe '#perform_later' do
    it 'verifica se o Job foi enfileirado com sucesso' do
      leader = create(:user)
      project = create(:project, user: leader)
      contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
      contributor_role = project.user_roles.create!(user: contributor)
      meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião sobre Caaptura de Pokémon')

      expect do
        NotifyParticipantsJob.perform_later(meeting)
      end.to have_enqueued_job
    end

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

    describe '#meeting_starts_soon?' do
      it 'edita o dia e hora da reunião e envia email para dois usuários' do
        leader = create(:user)
        project = create(:project, user: leader)
        contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
        contributor_role = project.user_roles.create!(user: contributor)
        meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião sobre Caaptura de Pokémon')
        create(:meeting_participant, user_role: contributor_role, meeting:)
        create(:meeting_participant, user_role: leader.user_roles.first, meeting:)

        mail = double('mail', deliver: true)
        mailer_double = double('MeetingMailer')

        allow(MeetingMailer).to receive(:with).and_return(mailer_double)
        allow(mailer_double).to receive(:notify_team_about_meeting).and_return(mail)

        meeting.update(datetime: 5.minutes.from_now)

        NotifyParticipantsJob.set(wait_until: meeting.datetime - 5.minutes).perform_now(meeting)

        expect(mail).to have_received(:deliver).twice
      end
    end
  end
end
