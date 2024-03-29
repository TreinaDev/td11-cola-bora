require 'rails_helper'

describe 'Usuário visualiza lista de colaboradores de um projeto' do
  context 'do qual é líder' do
    it 'a partir da home' do
      leader = create :user, email: 'leader@email.com'
      leader.profile.update! first_name: 'Líder', last_name: 'do Projeto'
      project = create :project, title: 'Projeto de listagem', user: leader
      admin = create :user, cpf: '040.363.060-65', email: 'admin@email.com'
      admin.profile.update! first_name: 'Admin', last_name: 'Silva'
      member1 = create :user, cpf: '367.767.000-44', email: 'nome_aleatorio@email.com'
      member1.profile.update! first_name: 'Nome', last_name: 'Aleatório'
      member2 = create :user, cpf: '434.508.190-46', email: 'membro@email.com'
      member2.profile.update! first_name: 'Membro', last_name: 'Dois'
      member3 = create :user, cpf: '527.181.910-82', email: 'email_como_nome@email.com'
      member3.profile.update! first_name: '', last_name: ''
      project.user_roles.create([{ user: admin, role: :admin },
                                 { user: member1 },
                                 { user: member2 },
                                 { user: member3 }])

      login_as leader, scope: :user
      visit projects_path
      click_on 'Projeto de listagem'
      within '#project-navbar' do
        click_on 'Colaboradores'
      end

      within 'thead' do
        expect(page).to have_content 'Nome'
        expect(page).to have_content 'E-mail'
        expect(page).to have_content 'Papel'
        expect(page).to have_content 'Ações'
      end
      within 'tbody' do
        within '#leader_row' do
          expect(page).to have_content 'Líder do Projeto'
          expect(page).to have_content 'leader@email.com'
          expect(page).to have_content 'Líder'
          expect(page).not_to have_link 'Gerenciar'
        end
        expect(page).to have_content 'Admin Silva'
        expect(page).to have_content 'admin@email.com'
        expect(page).to have_content 'Administrador', count: 1
        expect(page).to have_content 'Nome Aleatório'
        expect(page).to have_content 'nome_aleatorio@email.com'
        expect(page).to have_content 'Membro Dois'
        expect(page).to have_content 'membro@email.com'
        expect(page).to have_content 'email_como_nome'
        expect(page).to have_content 'email_como_nome@email.com'
        expect(page).to have_content 'Contribuidor', count: 3
        expect(page).to have_link 'Gerenciar', count: 4
      end
    end
  end

  context 'do qual participa' do
    it 'com sucesso' do
      leader = create :user, email: 'leader@email.com'
      leader.profile.update! first_name: 'Mestre', last_name: 'do Projeto'
      project = create :project, title: 'Projeto de listagem', user: leader
      admin = create :user, cpf: '040.363.060-65', email: 'admin@email.com'
      admin.profile.update! first_name: 'Admin', last_name: 'Silva'
      member1 = create :user, cpf: '367.767.000-44', email: 'nome_aleatorio@email.com'
      member1.profile.update! first_name: 'Nome', last_name: 'Aleatório'
      member2 = create :user, cpf: '434.508.190-46', email: 'membro@email.com'
      member2.profile.update! first_name: 'Membro', last_name: 'Dois'
      member3 = create :user, cpf: '527.181.910-82', email: 'email_como_nome@email.com'
      member3.profile.update! first_name: '', last_name: ''
      project.user_roles.create([{ user: admin, role: :admin },
                                 { user: member1 },
                                 { user: member2 },
                                 { user: member3 }])

      login_as member1, scope: :user
      visit members_project_path project

      within 'thead' do
        expect(page).to have_content 'Nome'
        expect(page).to have_content 'E-mail'
        expect(page).to have_content 'Papel'
        expect(page).not_to have_content 'Ações'
      end
      within 'tbody' do
        expect(page).to have_content 'Mestre do Projeto'
        expect(page).to have_content 'leader@email.com'
        expect(page).to have_content 'Líder', count: 1
        expect(page).to have_content 'Admin Silva'
        expect(page).to have_content 'admin@email.com'
        expect(page).to have_content 'Administrador', count: 1
        expect(page).to have_content 'Nome Aleatório'
        expect(page).to have_content 'nome_aleatorio@email.com'
        expect(page).to have_content 'Membro Dois'
        expect(page).to have_content 'membro@email.com'
        expect(page).to have_content 'email_como_nome'
        expect(page).to have_content 'email_como_nome@email.com'
        expect(page).to have_content 'Contribuidor', count: 3
        expect(page).not_to have_link 'Gerenciar'
      end
    end
  end
end
