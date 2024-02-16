require 'rails_helper'

describe 'Usuário acessa fórum' do
  it 'e não está autenticado' do
    user = create(:user)
    project = create(:project, user:)

    get project_forum_path(project)

    expect(response).to redirect_to new_user_session_path
  end

  context 'e deve ter acesso ao projeto' do
    it 'para ver o index' do
      leader = create(:user)
      project = create(:project, user: leader)

      login_as(leader, scope: :user)
      get project_forum_path(project)

      expect(response).to have_http_status :ok
    end

    it 'e não é colaborador' do
      leader = create(:user)
      project = create(:project, user: leader)
      not_contributor = create(:user, email: 'not_contributor@email.com', cpf: '000.000.001-91')

      login_as(not_contributor, scope: :user)
      get project_forum_path(project)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não é um colaborador desse projeto'
    end
  end
end
