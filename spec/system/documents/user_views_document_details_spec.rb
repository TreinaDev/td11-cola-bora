require 'rails_helper'

describe 'Usuário vê detalhes de um documento' do
  it 'do qual é dono' do
    user = create(:user)
    project = create(:project, title: 'Projeto teste', user:)
    document = project.documents.build(title: 'Documento teste', description: 'Descrição teste', user:)
    document.file.attach(io: File.open('spec/support/files/imagem1.jpg'), filename: 'imagem1.jpg')
    document.save!

    login_as user, scope: :user
    visit project_documents_path(project)
    click_on 'Documento teste'

    expect(page).to have_content 'Documento teste'
    expect(page).to have_content 'Descrição teste'
    expect(page).to have_selector 'img[src$="imagem1.jpg"]'
    expect(page).to have_link 'Download'
    expect(page).to have_button 'Arquivar'
    expect(page).to have_link 'Voltar', href: project_documents_path(project)
    expect(page).to have_current_path document_path(document)
  end

  it 'do qual não é dono'
end
