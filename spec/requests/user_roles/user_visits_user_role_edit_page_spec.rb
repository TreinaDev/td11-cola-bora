require 'rails_helper'

describe 'Usuário visita página de edição de papel de um projeto' do
  context 'do qual é líder' do
    it 'com sucesso' do
      leader = create :user
      project = create :project, user: leader
      admin = create :user, cpf: '518.642.180-45'
      admin_role = create :user_role, user: admin, project:, role: :admin

      login_as leader, scope: :user
      get edit_project_user_role_path(project, admin_role)

      expect(response).to have_http_status :ok
    end
  end

  context 'do qual é administrador' do
    it 'sem sucesso' do
      project = create :project
      admin = create :user, cpf: '518.642.180-45'
      admin_role = create :user_role, project:, user: admin, role: :admin

      login_as admin, scope: :user
      get edit_project_user_role_path project, admin_role

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Não foi possível completar a requisição'
    end
  end

  context 'do qual é contribuidor' do
    it 'sem sucesso' do
      project = create :project
      contributor = create :user, cpf: '111.863.720-87'
      contributor_role = create :user_role, project:, user: contributor

      login_as contributor, scope: :user
      get edit_project_user_role_path project, contributor_role

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Não foi possível completar a requisição'
    end
  end

  context 'do qual não é membro' do
    it 'sem sucesso' do
      project = create :project
      contributor = create :user, cpf: '461.560.280-48'
      contributor_role = create :user_role, project:, user: contributor
      non_member = create :user, cpf: '956.519.400-14'

      login_as non_member, scope: :user
      get edit_project_user_role_path project, contributor_role

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Não foi possível completar a requisição'
    end
  end
end
