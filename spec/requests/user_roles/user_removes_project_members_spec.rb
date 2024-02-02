require 'rails_helper'

describe 'Usuário remove um colaborador de um projeto' do
  context 'do qual é líder' do
    it 'com sucesso' do
      leader = create :user
      project = create :project, user: leader
      admin = create :user, cpf: '111.863.720-87'
      admin_role = create :user_role, user: admin, project:, role: :admin, active: true

      login_as leader, scope: :user
      patch remove_user_role_path(admin_role)

      expect(admin_role.reload.active).to be false
      expect(project.reload.member?(admin)).to be false
    end

    it 'sem sucesso se tentar remover a si mesmo' do
      leader = create :user
      project = create :project, user: leader
      leader_role = UserRole.last

      login_as leader, scope: :user
      patch remove_user_role_path(leader_role)

      expect(response).to redirect_to root_path
      expect(leader_role.reload.active).to be true
      expect(project.reload.leader?(leader)).to be true
    end
  end

  context 'do qual é administrador' do
    it 'sem sucesso' do
      project = create :project
      admin = create :user, cpf: '111.863.720-87'
      create :user_role, project:, user: admin, role: :admin
      contributor = create :user, cpf: '281.754.920-15'
      contributor_role = create :user_role, project:, user: contributor, role: :contributor

      login_as admin
      patch remove_user_role_path(contributor_role)

      expect(response).to redirect_to root_path
      expect(contributor_role.reload.active).to be true
      expect(project.reload.member?(contributor)).to be true
    end
  end

  context 'do qual é contribuidor' do
    it 'sem sucesso' do
      project = create :project
      admin = create :user, cpf: '111.863.720-87'
      admin_role = create :user_role, project:, user: admin, role: :admin
      contributor = create :user, cpf: '281.754.920-15'
      create :user_role, project:, user: contributor, role: :contributor

      login_as contributor
      patch remove_user_role_path(admin_role)

      expect(response).to redirect_to root_path
      expect(admin_role.reload.active).to be true
      expect(project.reload.member?(admin)).to be true
    end
  end

  context 'do qual não é colaborador' do
    it 'sem sucesso' do
      non_member = create :user, cpf: '281.754.920-15'
      project = create :project
      admin = create :user, cpf: '111.863.720-87'
      admin_role = create :user_role, user: admin, project:, role: :admin

      login_as non_member
      patch remove_user_role_path(admin_role)

      expect(response).to redirect_to root_path
      expect(admin_role.reload.active).to be true
      expect(project.reload.member?(admin)).to be true
    end
  end

  it 'sem estar autenticado' do
    project = create :project
    admin = create :user, cpf: '111.863.720-87'
    admin_role = create :user_role, project:, user: admin, role: :admin

    patch remove_user_role_path(admin_role)

    expect(response).to redirect_to new_user_session_path
    expect(admin_role.reload.active).to be true
    expect(project.reload.member?(admin)).to be true
  end
end
