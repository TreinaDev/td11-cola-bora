require 'rails_helper'

describe 'Usuário vê calendário' do
  it 'apenas de projeto que é colaborador' do
    leader = create(:user)
    project = create(:project, user: leader, title: 'Meu Projeto')
    other_project = create(:project, user: leader, title: 'Outro Projeto')

    user = create(:user, cpf: '111.863.720-87')
    create(:user_role, project:, user:, role: :contributor)

    login_as user
    get project_calendars_path(other_project)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
  end

  it 'apenas se estiver autenticado' do
    project = create(:project, title: 'Meu Projeto')

    get project_calendars_path(project)

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end
end
