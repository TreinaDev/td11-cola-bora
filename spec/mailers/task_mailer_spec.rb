require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe '#notify_leader_finish_task' do
    it 'e crio o email com sucesso' do
      project = create(:project, title: 'Mestre Pokémon')
      contributor = create(:user, cpf: '167.882.240-05')
      contributor_role = create(:user_role, project:, user: contributor)
      task = create(:task, title: 'Captura 150 pokemons', user_role: contributor_role, project:)

      mail = TaskMailer.with(task:).notify_leader_finish_task(project, task)

      expect(mail.body.encoded).to include 'A tarefa Captura 150 pokemons do projeto Mestre Pokémon foi finalizada.<br>'
    end
  end
end
