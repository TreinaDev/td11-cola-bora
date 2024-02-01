require 'rails_helper'

describe 'Líder gerencia papéis de projeto' do
  context 'com sucesso' do
    it 'a partir da home' do
      leader = create :user
      project = create :project, user: leader, title: 'Gerenciamento de Usuários'
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
      end
      within "#user_role_#{contributor_role.id}_row" do
        expect(page).to have_content 'Contribuidor'
      end
      expect(project.reload.admins).to include future_admin_role
      expect(project.admins).not_to include contributor_role
      expect(project.contributors).not_to include future_admin_role
      expect(project.contributors).to include contributor_role
    end
  end
end
