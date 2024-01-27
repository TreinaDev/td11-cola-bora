require 'rails_helper'

describe 'Usuário acessa reunião' do
  context 'e deve estar autenticado' do
    it 'para acessar o index' do
      project = create(:project)

      get project_meetings_path(project)

      expect(response).to redirect_to new_user_session_path
    end

    it 'para acessar o show' do
      user = create(:user)
      project = create(:project, user:)
      meeting = create(:meeting, project:)

      get(project_meeting_path(project, meeting))

      expect(response).to redirect_to new_user_session_path
    end

    it 'para acessar o edit' do
      project = create(:project)
      meeting = create(:meeting, project:)

      get edit_project_meeting_path(project, meeting)

      expect(response).to redirect_to new_user_session_path
    end

    it 'para acessar o new' do
      project = create(:project)
      get new_project_meeting_path(project)

      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'e deve ter acesso ao projeto' do
    it 'para ver o index' do
      leader = create(:user)
      project = create(:project, user: leader)
      meeting = create(:meeting, project:)
      not_contributor = create(:user, email: 'not_contributor@email.com', cpf: '000.000.001-91')

      login_as(not_contributor, scope: :user)
      get project_meeting_path(project, meeting)

      expect(response).to redirect_to root_path
    end

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
      meeting = create(:meeting, project:)
      not_contributor = create(:user, email: 'not_contributor@email.com', cpf: '000.000.001-91')

      login_as(not_contributor, scope: :user)
      get edit_project_meeting_path(project, meeting)

      expect(response).to redirect_to root_path
    end

    it 'para ver o new' do
      leader = create(:user)
      project = create(:project, user: leader)
      not_contributor = create(:user, email: 'not_contributor@email.com', cpf: '000.000.001-91')

      login_as(not_contributor, scope: :user)
      get new_project_meeting_path(project)

      expect(response).to redirect_to root_path
    end
  end
end
