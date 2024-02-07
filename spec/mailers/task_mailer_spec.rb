require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe '#notify_leader_finish_task' do
    it 'e crio o email com sucesso' do
      project = create(:project, title: 'Mestre Pokémon')
      contributor = create(:user, cpf: '167.882.240-05')
      create(:profile, first_name: 'Giovanni', last_name: '', user: contributor)
      contributor_role = create(:user_role, project:, user: contributor)
      task = create(:task, title: 'Captura 150 pokemons', user_role: contributor_role, project:)
      url = project_task_url(project, task, host: 'http://127.0.0.1:3000/')

      mail = TaskMailer.with(task:, url:).notify_leader_finish_task

      expect(mail.body.encoded).to include 'A tarefa Captura 150 pokemons do projeto Mestre Pokémon'
      expect(mail.body.encoded).to include 'foi finalizada por Giovanni.'
      expect(mail.subject).to include 'A tarefa foi finalizada.'
      link = '<a href="http://127.0.0.1/projects/1/tasks/1">Para ver a tarefa pronta, acesse</a>'
      expect(mail.body.encoded).to include link
    end
  end
end
