require 'rails_helper'

describe 'Usuário vê detalhes do projeto' do
  it 'A partir da home' do
    deco = create :user, email: 'deco@email.com'
    create :project, user: deco, title: 'Padrão', description: 'Descrição de um projeto padrão para testes',
                     category: 'Teste'
    project = create :project, title: 'Criação de site',
                               description: 'Esse projeto é sobre a criação de um website para a cidade',
                               category: 'Webdesign', user: deco

    login_as deco
    visit root_path
    click_on 'Projetos'
    click_on 'Criação de site'

    expect(current_path).to eq project_path(project)
    expect(page).to have_content 'Projeto: Criação de site'
    expect(page).to have_content 'Autor: deco@email.com'
    expect(page).to have_content 'Descrição: Esse projeto é sobre a criação de um website para a cidade'
    expect(page).to have_content 'Categoria: Webdesign'
    expect(page).not_to have_content 'Título: Padrão'
    expect(page).not_to have_content 'Descrição: Descrição de um projeto padrão para testes'
    expect(page).not_to have_content 'Categoria: Teste'
  end

  it 'e deve estar autenticado' do
    deco = create :user, email: 'deco@email.com'
    project = create :project, user: deco, title: 'Padrão', description: 'Descrição de um projeto padrão para testes',
                               category: 'Teste'

    visit project_path(project)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
    expect(page).not_to have_content 'Projeto: Padrão'
    expect(page).not_to have_content 'Autor: deco@email.com'
    expect(page).not_to have_content 'Descrição: Descrição de um projeto padrão para testes'
    expect(page).not_to have_content 'Categoria: Teste'
  end

  it 'que não existe' do
    deco = create :user, email: 'deco@email.com'

    login_as deco
    visit project_path('999')

    expect(current_path).to eq root_path
    expect(page).to have_content 'Projeto não encontrado.'
  end
end
