require 'rails_helper'

RSpec.describe Project, type: :request do
  describe 'POST /projects' do
    it 'e deve estar autenticado' do
      user = create :user
      project_params = { title: 'Mewtwo', description: 'Um projeto para criar um pokémon.', category: 'Jogo', user: }
      initial_project_count = Project.count

      post projects_path, params: { project: project_params }
      project_count = Project.count

      expect(response).to redirect_to new_user_session_path
      expect(project_count).to eq(initial_project_count)
    end

    it 'com sucesso' do
      user = create :user
      project_params = { title: 'Mewtwo', description: 'Um projeto para criar um pokémon.', category: 'Jogo', user: }
      initial_project_count = Project.count

      login_as(user)
      post projects_path, params: { project: project_params }

      expect(Project.count).to eq(initial_project_count + 1)
      expect(response).not_to redirect_to new_user_session_path
    end
  end

  describe 'DELETE /projects/:id' do
    it 'deleta projeto se usuário é o dono do projeto' do
      project_owner = create(:user)
      project = create(:project, user: project_owner)
      create(:project, user: project_owner)

      login_as project_owner, scope: :user
      delete project_path(project)

      expect(response).to redirect_to my_projects_projects_path
      expect(Project.count).to eq 1
    end

    it 'não deleta um projeto de outro usuário' do
      project_owner = create(:user)
      project = create(:project, user: project_owner)
      other_user = create(:user, cpf: '440.502.910-53', email: 'otheruser@email.com')

      login_as other_user, scope: :user
      delete project_path(project)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não é um colaborador desse projeto'
      expect(Project.count).to eq 1
      expect(Project.last).to eq project
    end

    it 'não deleta um projeto sem estar logado' do
      project = create(:project)

      delete project_path(project)

      expect(response).to redirect_to new_user_session_path
      expect(Project.count).to eq 1
      expect(Project.last).to eq project
    end
  end
end
