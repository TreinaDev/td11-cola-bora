require 'rails_helper'

describe 'DELETE /projects/:id' do
  it 'deleta projeto se usuário é o dono do projeto' do
    project_owner = create(:user)
    project = create(:project, user: project_owner)
    create(:project, user: project_owner)

    login_as project_owner, scope: :user
    delete project_path(project)

    expect(response).to redirect_to my_projects_path
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
