require 'rails_helper'

describe 'Usuário acessa projeto' do
  context 'e deve estar autenticado' do
    it 'para acessar o show' do
      project = create(:project)

      get(project_path(project))

      expect(response).to redirect_to new_user_session_path
    end

    it 'para acessar o edit' do
      project = create(:project)

      get edit_project_path(project)

      expect(response).to redirect_to new_user_session_path
    end

    it 'para acessar o new' do
      project = create(:project)

      get new_project_path(project)

      expect(response.status).to eq 401
      expect(response.body).to eq 'Para continuar, faça login ou registre-se.'
    end
  end

  context 'e deve ter acesso ao projeto' do
    it 'para ver o show' do
      leader = create(:user)
      project = create(:project, user: leader)
      not_contributor = create(:user, email: 'not_contributor@email.com', cpf: '000.000.001-91')

      login_as(not_contributor, scope: :user)
      get project_meetings_path(project)

      expect(response).to redirect_to root_path
    end

    it 'para ver o edit' do
      leader = create(:user)
      project = create(:project, user: leader)
      not_contributor = create(:user, email: 'not_contributor@email.com', cpf: '000.000.001-91')

      login_as(not_contributor, scope: :user)
      get edit_project_path(project)

      expect(response).to redirect_to root_path
    end
  end
end
