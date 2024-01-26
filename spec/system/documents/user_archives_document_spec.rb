require 'rails_helper'

describe 'Usuário arquiva um documento' do
  it 'com sucesso' do
    project = create(:project)
    contributor = create(:user, cpf: '989.933.890-71')
    project.user_roles.create!(user: contributor)
    document1 = create(:document, project:, title: 'Primeiro documento', user: contributor)
    create(:document, project:, title: 'Segundo documento', user: contributor)

    login_as contributor, scope: :user
    visit document_path(document1)
    accept_confirm('Arquivar documento?') { click_on 'Arquivar' }

    expect(page).to have_current_path project_documents_path(project)
    expect(page).not_to have_content 'Primeiro documento'
    expect(page).to have_content 'Segundo documento'
    expect(page).to have_content 'Documento arquivado com sucesso.'
  end
end
