require 'rails_helper'

describe 'Usuário arquiva um documento' do
  it 'com sucesso' do
    project = create(:project)
    contributor = create(:user, cpf: '989.933.890-71', email: 'contributor@email.com')
    project.user_roles.create!(user: contributor)
    document = project.documents.create! do |d|
      d.user = contributor
      d.title = 'Documento teste'
      d.description = 'Descrição teste'
      d.file.attach(io: File.open('spec/support/files/imagem1.jpg'), filename: 'imagem1.jpg')
    end

    login_as contributor, scope: :user
    visit document_path(document)
    click_on 'Arquivar'

    expect(page).to have_current_path project_documents_path(project)
    expect(page).not_to have_link 'Documento teste'
    expect(page).not_to have_selector 'img[src$="imagem1.jpg"]'
    expect(page).to have_content 'Documento arquivado com sucesso.'
  end
end
