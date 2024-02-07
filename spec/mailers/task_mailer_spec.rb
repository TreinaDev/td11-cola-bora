require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe '#notify_leader_finish_task' do
    it 'e crio o email com sucesso' do
      project = create(:project, title: 'Mestre Pokémon')
      contributor = create(:user, cpf: '167.882.240-05')
      profile = create(:profile, first_name: 'Giovanni', last_name: '', user: contributor)
      contributor_role = create(:user_role, project:, user: contributor)
      task = create(:task, title: 'Captura 150 pokemons', user_role: contributor_role, project:)

      mail = TaskMailer.with(task:).notify_leader_finish_task(task)

      # nome ou email do user
      # nome da task
      # subject
      expect(mail.body.encoded).to include 'A tarefa Captura 150 pokemons do projeto Mestre Pokémon'
      expect(mail.body.encoded).to include 'foi finalizada por Giovanni.<br>'
    end
  end
end
