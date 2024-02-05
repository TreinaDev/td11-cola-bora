require 'rails_helper'

describe 'Usuário gerencia papel de projeto' do
  context 'do qual é líder' do
    it 'e muda administrador para contribuidor com sucesso' do
      leader = create :user
      project = create :project, user: leader
      future_contributor = create :user, cpf: '111.863.720-87'
      future_contributor_role = create :user_role, user: future_contributor, project:, role: :admin
      params = { user_role: { role: :contributor } }

      login_as leader, scope: :user
      patch(project_user_role_path(project, future_contributor_role), params:)

      expect(response).to redirect_to members_project_path(project)
      expect(future_contributor_role.reload.role).to eq 'contributor'
    end

    it 'e muda contribuidor para administrador com sucesso' do
      leader = create :user
      project = create :project, user: leader
      future_admin = create :user, cpf: '111.863.720-87'
      future_admin_role = create :user_role, project:, user: future_admin, role: :contributor
      params = { user_role: { role: :admin } }

      login_as leader, scope: :user
      patch(project_user_role_path(project, future_admin_role), params:)

      expect(response).to redirect_to members_project_path(project)
      expect(future_admin_role.reload.role).to eq 'admin'
    end

    it 'mas não consegue modificar para um papel inexistente' do
      leader = create :user
      project = create :project, user: leader
      admin = create :user, cpf: '111.863.720-87'
      admin_role = create :user_role, user: admin, project:, role: :admin
      params = { user_role: { role: 'foo' } }

      login_as leader, scope: :user
      patch(project_user_role_path(project, admin_role), params:)

      expect(response).to have_http_status :unprocessable_entity
      expect(flash[:alert]).to eq 'Não foi possível completar a requisição'
      expect(admin_role.reload.role).to eq 'admin'
    end

    it 'e não consegue transformar outro usuário em líder' do
      leader = create :user
      project = create :project, user: leader
      contributor = create :user, cpf: '111.863.720-87'
      contributor_role = create :user_role, user: contributor, project:, role: :contributor
      params = { user_role: { role: 'leader' } }

      login_as leader, scope: :user
      patch(project_user_role_path(project, contributor_role), params:)

      expect(response).to have_http_status :unprocessable_entity
      expect(flash[:alert]).to eq 'Não foi possível completar a requisição'
      expect(contributor_role.reload.role).to eq 'contributor'
    end

    it 'e não consegue mudar o papel do líder para outro tipo' do
      leader = create :user
      project = create :project, user: leader
      leader_role = UserRole.last
      params = { user_role: { role: :contributor } }

      login_as leader, scope: :user
      patch(project_user_role_path(project, leader_role), params:)

      expect(response).to redirect_to root_path
      expect(leader_role.reload.role).to eq 'leader'
    end
  end

  context 'do qual é administrador' do
    it 'sem sucesso' do
      project = create :project
      admin = create :user, cpf: '281.754.920-15'
      create :user_role, user: admin, project:, role: :admin
      contributor = create :user, cpf: '137.329.810-37'
      contributor_role = create :user_role, user: contributor, project:, role: :contributor
      params = { user_role: { role: :admin } }

      login_as admin, scope: :user
      patch(project_user_role_path(project, contributor_role), params:)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Não foi possível completar a requisição'
      expect(contributor_role.reload.role).to eq 'contributor'
    end
  end

  context 'do qual é contribuidor' do
    it 'sem sucesso' do
      project = create :project
      contributor = create :user, cpf: '281.754.920-15'
      create :user_role, user: contributor, project:, role: :contributor
      admin = create :user, cpf: '137.329.810-37'
      admin_role = create :user_role, user: admin, project:, role: :admin
      params = { user_role: { role: :contributor } }

      login_as contributor, scope: :user
      patch(project_user_role_path(project, admin_role), params:)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Não foi possível completar a requisição'
      expect(admin_role.reload.role).to eq 'admin'
    end
  end

  context 'do qual não faz parte' do
    it 'sem sucesso' do
      project = create :project
      contributor = create :user, cpf: '281.754.920-15'
      contributor_role = create :user_role, project:, user: contributor, role: :contributor
      non_member = create :user, cpf: '390.698.050-22'
      params = { user_role: { role: :admin } }

      login_as non_member, scope: :user
      patch(project_user_role_path(project, contributor_role), params:)

      expect(response).to redirect_to root_path
      expect(contributor_role.reload.role).to eq 'contributor'
    end
  end

  context 'não autenticado' do
    it 'sem sucesso' do
      project = create :project
      contributor = create :user, cpf: '985.557.220-39'
      contributor_role = create :user_role, project:, user: contributor, role: :contributor
      params = { user_role: { role: :admin } }

      patch(project_user_role_path(project, contributor_role), params:)

      expect(response).to redirect_to new_user_session_path
      expect(contributor_role.reload.role).to eq 'contributor'
    end
  end
end
