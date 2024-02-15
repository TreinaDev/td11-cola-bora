require 'rails_helper'

describe 'Usuário anexa documento ao projeto' do
  context 'com sucesso' do
    it 'a partir da home' do
      user = create(:user)
      project = create(:project, title: 'Projeto teste', user:)

      login_as user, scope: :user
      visit root_path
      within '#navbar' do
        click_on 'Projetos'
      end
      click_on 'Projeto teste'
      click_on 'Documentos'
      click_on 'Novo documento'
      fill_in 'Título',	with: 'Documento teste'
      fill_in 'Descrição',	with: 'Descrição teste'
      attach_file 'Arquivo', Rails.root.join('spec/support/files/sample_jpg.jpg')
      click_on 'Criar Documento'

      expect(page).to have_current_path document_path(project.documents.last)
      expect(page).to have_content 'Documento teste'
      expect(page).to have_content 'Documento adicionado com sucesso'
    end
  end

  context 'sem sucesso' do
    it 'com campos inválidos' do
      user = create(:user)
      project = create(:project, user:)

      login_as user, scope: :user
      visit new_project_document_path(project)
      fill_in 'Título', with: ''
      fill_in 'Descrição', with: 'Descrição teste'
      click_on 'Criar Documento'

      expect(page).to have_content 'Não foi possível adicionar o documento'
      expect(page).to have_content 'Título não pode ficar em branco'
      expect(page).to have_content 'Arquivo não pode ficar em branco'
      expect(page).to have_field 'Título'
      expect(page).to have_field 'Descrição', with: 'Descrição teste'
    end

    it 'com tipo de arquivo inválido' do
      user = create(:user)
      project = create(:project, user:)

      login_as user, scope: :user
      visit new_project_document_path(project)
      fill_in 'Título', with: 'Título de teste'
      attach_file 'Arquivo', Rails.root.join('spec/support/files/invalid_upload_file.txt')
      click_on 'Criar Documento'

      expect(page).to have_content 'Arquivo não suportado.'
      expect(page).to have_field 'Título', with: 'Título de teste'
      expect(project.documents).to be_empty
    end
  end

  it 'mas desiste e retorna a listagem de documentos' do
    user = create(:user)
    project = create(:project, user:)

    login_as user, scope: :user
    visit new_project_document_path(project)
    click_on 'Voltar'

    expect(page).to have_current_path project_documents_path(project)
  end
end
