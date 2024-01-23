require 'rails_helper'

describe 'usuário anexa documento ao projeto' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, title: 'Projeto teste', user:)

    login_as user, scope: :user
    visit root_path
    within 'nav' do
      click_on 'Projetos'
    end
    click_on 'Projeto teste'
    click_on 'Documentos'
    click_on 'Novo documento'
    fill_in 'Título',	with: 'Documento teste'
    fill_in 'Descrição',	with: 'Descrição teste'
    attach_file 'Arquivo', Rails.root.join('spec/support/files/imagem1.jpg')
    click_on 'Salvar documento'

    expect(page).to have_current_path project_documents_path(project)
    expect(page).to have_content 'Documento teste'
    expect(page).to have_selector 'img[src$="imagem1.jpg"]'
    expect(page).to have_content 'Documento adicionado com sucesso'
  end
end
