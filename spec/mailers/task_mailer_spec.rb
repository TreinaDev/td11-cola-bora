require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe '#notify_leader_finish_task' do
    it 'e colaborador finaliza tarefa com sucesso' do
      project = create(:project, title: 'Mestre Pokémon')
      project.user.profile.first_name = 'Ash Ketchum'
      contributor = create(:user, cpf: '167.882.240-05')
      create(:profile, first_name: 'Giovanni', last_name: '', user: contributor)
      contributor_role = create(:user_role, project:, user: contributor)
      task = create(:task, title: 'Captura 150 pokemons', user_role: contributor_role, project:)

      mail = TaskMailer.with(task:).notify_leader_finish_task

      expect(mail.body.encoded).to include 'Olá Ash Ketchum. Uma tarefa foi finalizada!'
      expect(mail.body.encoded).to include 'A tarefa Captura 150 pokemons, do projeto Mestre Pokémon e '
      expect(mail.body.encoded).to include 'criada por Giovanni foi finalizada.'
      expect(mail.subject).to include 'A tarefa foi finalizada.'
      link = '<a href="http://localhost:3000/projects/1/tasks/1">Para ver a tarefa pronta, acesse</a>'
      expect(mail.body.encoded).to include link
    end

    it 'e lider finaliza tarefa com sucesso' do
      project = create(:project, title: 'Mestre Pokémon')
      create(:user, cpf: '167.882.240-05')
      project.user.profile.first_name = 'Ash Ketchum'
      author = project.user.user_roles.first
      task = create(:task, title: 'Captura 150 pokemons', user_role: author, project:)

      mail = TaskMailer.with(task:).notify_leader_finish_task

      expect(mail.body.encoded).to include 'Olá Ash Ketchum. Uma tarefa foi finalizada!'
      expect(mail.body.encoded).to include 'A tarefa Captura 150 pokemons, do projeto Mestre Pokémon e '
      expect(mail.body.encoded).to include 'criada por você foi finalizada'
      expect(mail.subject).to include 'A tarefa foi finalizada.'
      link = '<a href="http://localhost:3000/projects/1/tasks/1">Para ver a tarefa pronta, acesse</a>'
      expect(mail.body.encoded).to include link
    end
  end
end
