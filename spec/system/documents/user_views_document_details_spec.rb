require 'rails_helper'

describe 'Colaborador vê detalhes de um documento' do
  it 'que ele adicionou ao projeto' do
    project = create(:project, title: 'Projeto teste')
    contributor = create(:user, cpf: '391.503.760-55', email: 'user@email.com')
    project.user_roles.create!(user: contributor)
    document = project.documents.create! do |d|
      d.title = 'Documento teste'
      d.description = 'Descrição teste'
      d.user = contributor
      d.file.attach(io: File.open('spec/support/files/imagem1.jpg'), filename: 'imagem1.jpg')
    end

    login_as contributor, scope: :user
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

  it 'que ele não adicionou ao projeto' do
    project = create(:project, title: 'Projeto Teste')
    document_creator = create(:user, cpf: '492.294.960-73', email: 'contributor1@email.com')
    contributor = create(:user, cpf: '958.314.240-90', email: 'contributor2@email.com')
    project.user_roles.create!([{ user: document_creator }, { user: contributor }])
    document = project.documents.create! do |d|
      d.user = document_creator
      d.title = 'Documento teste'
      d.description = 'Descrição teste'
      d.file.attach(io: File.open('spec/support/files/imagem1.jpg'), filename: 'imagem1.jpg')
    end

    login_as contributor
    visit document_path document

    expect(page).to have_content 'Documento teste'
    expect(page).to have_content 'Descrição teste'
    expect(page).to have_selector 'img[src$="imagem1.jpg"]'
    expect(page).to have_link 'Download'
    expect(page).not_to have_button 'Arquivar'
  end
end
