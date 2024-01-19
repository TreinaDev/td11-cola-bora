require 'rails_helper'

describe 'Usuário deleta projeto' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, title: 'Projeto teste', user:)

    login_as user, scope: :user
    visit project_path project
    click_on 'Editar Projeto'
    accept_confirm('Deletar projeto?') { click_on 'Deletar' }

    expect(page).to have_current_path root_path
    expect(Project.all).to be_empty
    expect(page).to have_content 'Projeto deletado com sucesso!'
    expect(page).not_to have_content 'Projeto teste'
  end
end
