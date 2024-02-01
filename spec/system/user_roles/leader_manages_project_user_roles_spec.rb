require 'rails_helper'

describe 'Líder gerencia papel de usuário' do
  context 'com sucesso' do
    it 'de contribuidor para administrador' do
      leader = create :user
      project = create :project, user: leader
      future_admin = create :user, cpf: '010.124.800-89'
      contributor = create :user, cpf: '186.991.930-09'
      future_admin_role = create(:user_role, user: future_admin, project:)
      contributor_role = create(:user_role, user: contributor, project:)

      login_as leader, scope: :user
      visit project_path(project)
      click_on 'Colaboradores'
      within "#user_role_#{future_admin_role.id}_row" do
        click_on 'Gerenciar'
      end
      select 'Administrador', from: 'user_role_role'
      click_on 'Salvar'

      expect(page).to have_current_path members_project_path(project)
      expect(page).to have_content 'Colaborador atualizado com sucesso'
      within "#user_role_#{future_admin_role.reload.id}_row" do
        expect(page).to have_content 'Administrador'
        expect(page).not_to have_content 'Contribuidor'
      end
      within "#user_role_#{contributor_role.id}_row" do
        expect(page).to have_content 'Contribuidor'
      end
      expect(project.reload.admins).to include future_admin_role
      expect(project.admins).not_to include contributor_role
      expect(project.contributors).not_to include future_admin_role
      expect(project.contributors).to include contributor_role
    end

    it 'de administrador para contribuidor' do
      leader = create :user
      project = create :project, user: leader, title: 'Gerenciamento de Usuários'
      future_contributor = create :user, cpf: '010.124.800-89'
      admin = create :user, cpf: '186.991.930-09'
      future_contributor_role = create(:user_role, user: future_contributor,
                                                   project:, role: :admin)
      admin_role = create(:user_role, user: admin, project:, role: :admin)

      login_as leader, scope: :user
      visit members_project_path project
      within "#user_role_#{future_contributor_role.reload.id}_row" do
        click_on 'Gerenciar'
      end
      select 'Contribuidor', from: 'user_role_role'
      click_on 'Salvar'

      expect(page).to have_current_path members_project_path(project)
      expect(page).to have_content 'Colaborador atualizado com sucesso'
      within "#user_role_#{future_contributor_role.reload.id}_row" do
        expect(page).to have_content 'Contribuidor'
        expect(page).not_to have_content 'Administrador'
      end
      within "#user_role_#{admin_role.id}_row" do
        expect(page).to have_content 'Administrador'
      end
      expect(project.reload.contributors).to include future_contributor_role
      expect(project.contributors).not_to include admin_role
      expect(project.admins).not_to include future_contributor_role
      expect(project.admins).to include admin_role
    end
  end
end
