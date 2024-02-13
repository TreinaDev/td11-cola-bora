require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe '#notify_team_about_meeting' do
    it 'com sucesso' do
      travel_to Time.zone.local(2024, 11, 23, 14, 0, 0)
      project = create(:project, title: 'Mestre Pokémon')
      contributor = create(:user, cpf: '167.882.240-05')
      create(:profile, first_name: 'Ash', last_name: 'Ketchum', user: contributor)
      contributor_role = create(:user_role, project:, user: contributor)
      meeting = create(:meeting, project:, user_role: contributor_role, title: 'Como derrotar a Equipe Rocket',
                                 datetime: Time.zone.local(2024, 11, 24, 14, 0, 0))

      mail = MeetingMailer.with(meeting:, participant: contributor).notify_team_about_meeting

      expect(mail.body.encoded).to include 'Olá, Ash Ketchum.'
      expect(mail.body.encoded).to include 'A reunião Como derrotar a Equipe Rocket'
      expect(mail.body.encoded).to include 'marcada para 24/11/24 às 14:00 horas,'
      expect(mail.body.encoded).to include 'começa em 5 minutos'
      expect(mail.subject).to include 'Sua reunião já vai começar.'
      link = '<a href="http://localhost:3000/projects/1/meetings/1">Clique aqui para ver os detalhes da reunião.</a>'
      expect(mail.body.encoded).to include link
      travel_back
    end
  end
end
