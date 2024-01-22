require 'rails_helper'

describe 'Usuário deleta projeto' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, title: 'Projeto teste', user:)

    login_as user, scope: :user
    visit project_path project
    click_on 'Editar Projeto'
    accept_confirm('Deletar projeto?') { click_on 'Deletar' }

    expect(page).to have_current_path my_projects_projects_path
    expect(Project.all).to be_empty
    expect(page).to have_content 'Projeto deletado com sucesso!'
    expect(page).not_to have_content 'Projeto teste'
  end

  it 'e cancela deleção' do
    user = create(:user)
    project = create(:project, title: 'Projeto teste', user:)

    login_as user, scope: :user
    visit project_path project
    click_on 'Editar Projeto'
    dismiss_confirm('Deletar projeto?') { click_on 'Deletar' }

    expect(page).to have_current_path edit_project_path(project)
    expect(Project.count).to eq 1
    expect(page).not_to have_content 'Projeto deletado com sucesso!'
  end
end
