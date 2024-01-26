require 'rails_helper'

describe 'Colaborador vê detalhes de um documento' do
  it 'que ele adicionou ao projeto' do
    project = create(:project, title: 'Projeto teste')
    contributor = create(:user, cpf: '391.503.760-55', email: 'user@email.com')
    project.user_roles.create!(user: contributor)
    document = create(
      :document,
      project:,
      title: 'Documento teste',
      description: 'Descrição teste',
      user: contributor,
      file: fixture_file_upload('spec/support/files/imagem1.jpg')
    )

    login_as contributor, scope: :user
    visit project_documents_path(project)
    click_on 'Detalhes'

    expect(page).to have_current_path document_path(document)
    expect(page).to have_content 'Documento teste'
    expect(page).to have_content 'Descrição teste'
    expect(page).to have_content 'user@email.com'
    expect(page).to have_content I18n.l(Time.zone.today).to_s
    expect(page).to have_selector 'img[src$="imagem1.jpg"]'
    expect(page).to have_content 'imagem1.jpg'
    expect(page).to have_content '2,32 KB'
    expect(page).to have_link 'Download'
    expect(page).to have_button 'Arquivar'
    expect(page).to have_link 'Voltar', href: project_documents_path(project)
  end

  it 'que ele não adicionou ao projeto' do
    project = create(:project, title: 'Projeto Teste')
    document_creator = create(:user, cpf: '492.294.960-73')
    contributor = create(:user, cpf: '958.314.240-90')
    project.user_roles.create!([{ user: document_creator }, { user: contributor }])
    document = create(
      :document,
      project:,
      user: document_creator,
      title: 'Documento teste', description: 'Descrição teste',
      file: fixture_file_upload('spec/support/files/imagem1.jpg')
    )

    login_as contributor
    visit document_path document

    expect(page).to have_content 'Documento teste'
    expect(page).to have_content 'Descrição teste'
    expect(page).to have_selector 'img[src$="imagem1.jpg"]'
    expect(page).to have_link 'Download'
    expect(page).not_to have_button 'Arquivar'
  end

  it 'de um projeto ao qual ele não pertence' do
    project = create(:project)
    contributor = create(:user, cpf: '760.378.330-52')
    document = create(:document, project:, user: contributor)
    non_contributor = create(:user, cpf: '123.405.150-84')

    login_as non_contributor, scope: :user
    visit document_path(document)

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Você não é membro deste projeto'
  end
end
