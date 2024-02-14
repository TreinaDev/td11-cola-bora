require 'rails_helper'

describe 'Usuário visita lista de convites de um projeto' do
  context 'do qual é líder' do
    it 'com sucesso' do
      leader = create :user
      project = create :project, user: leader

      login_as leader, scope: :user
      get project_invitations_path project

      expect(response).to have_http_status :ok
    end
  end

  context 'do qual é administrador' do
    it 'sem sucesso' do
      project = create :project
      admin = create :user, cpf: '518.642.180-45'
      create :user_role, project:, user: admin, role: :admin

      login_as admin, scope: :user
      get project_invitations_path project

      expect(response).to redirect_to project_path project
      expect(flash[:alert]).to eq 'Você não possui permissão para prosseguir'
    end
  end

  context 'do qual é contribuidor' do
    it 'sem sucesso' do
      project = create :project
      contributor = create :user, cpf: '518.642.180-45'
      create :user_role, project:, user: contributor, role: :contributor

      login_as contributor, scope: :user
      get project_invitations_path project

      expect(response).to redirect_to project_path project
      expect(flash[:alert]).to eq 'Você não possui permissão para prosseguir'
    end
  end

  context 'do qual não é membro' do
    it 'sem sucesso' do
      project = create :project
      non_contributor = create :user, cpf: '518.642.180-45'

      login_as non_contributor, scope: :user
      get project_invitations_path project

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não é um colaborador desse projeto'
    end
  end

  context 'não autenticado' do
    it 'sem sucesso' do
      project = create :project

      get project_invitations_path project

      expect(response).to redirect_to new_user_session_path
    end
  end
end
