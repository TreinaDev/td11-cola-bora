require 'rails_helper'

describe 'Usuário vê lista de documentos' do
  it 'vazia' do
    project = create(:project)
    contributor = create(:user, cpf: '459.103.780-07')
    project.user_roles.create(user: contributor)

    login_as contributor, scope: :user
    visit project_documents_path(project)

    expect(page).to have_content 'Nenhum documento encontrado'
    expect(page).to have_link 'Novo documento', href: new_project_document_path(project)
  end

  it 'com documentos anexados' do
    project = create(:project)
    contributor1 = create(:user, cpf: '552.570.570-26', email: 'contributor1@email.com')
    contributor2 = create(:user, cpf: '529.741.720-16', email: 'contributor2@email.com')
    user = create(:user, cpf: '774.241.710-38', email: 'user@email.com')
    project.user_roles.create!([{ user: contributor1 }, { user: contributor2 },
                                { user: }])
    project.documents.create!(
      [{ user: contributor1, title: 'Imagem', description: 'Documento de imagem',
         file: fixture_file_upload('spec/support/files/sample_jpg.jpg') },
       { user: contributor2, title: 'Doc pdf', description: 'Documento em PDF',
         file: fixture_file_upload('spec/support/files/sample_pdf.pdf') }]
    )

    login_as user, scope: :user
    visit project_documents_path(project)

    expect(page).not_to have_content 'Nenhum documento encontrado'
    within 'table' do
      expect(page).to have_content 'Título'
      expect(page).to have_content 'Tipo'
      expect(page).to have_content 'Autor'
      expect(page).to have_content 'Criado em'
      expect(page).to have_content 'Imagem'
      expect(page).to have_content 'JPG'
      expect(page).to have_content 'contributor1@email.com'
      expect(page).to have_content I18n.l(project.documents.first.created_at.to_date)
      expect(page).to have_content 'Doc pdf'
      expect(page).to have_content 'PDF'
      expect(page).to have_content 'contributor2@email.com'
      expect(page).to have_content I18n.l(project.documents.second.created_at.to_date)
      expect(page).to have_link 'Detalhes', count: 2
      expect(page).to have_link 'Download', count: 2
    end
  end
end
