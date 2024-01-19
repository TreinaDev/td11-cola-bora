require 'rails_helper'
# todos os projetos da plataforma
describe 'Usuário vê projetos' do
  it 'e deve estar autenticado' do
    visit projects_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'a partir da home com sucesso' do
    deco = create :user, email: 'deco@email.com'
    mateus = create :user, email: 'mateus@email.com', cpf: '096.505.460-81'
    create :project, user: deco, title: 'Padrão', description: 'Descrição de um projeto padrão para testes',
                     category: 'Teste'
    create :project, title: 'Criação de site',
                     description: 'Esse projeto é sobre a criação de um website para a cidade',
                     category: 'Webdesign', user: deco
    create :project, title: 'Peça de Teatro', description: 'Espetáculo de Shakespeare', category: 'Teatro', user: mateus

    login_as mateus
    visit root_path
    click_on 'Projetos'

    expect(current_path).to eq projects_path
    expect(page).to have_content 'Título: Padrão'
    expect(page).to have_content 'Descrição: Descrição de um projeto padrão para testes'
    expect(page).to have_content 'Categoria: Teste'
    expect(page).to have_content 'Título: Criação de site'
    expect(page).to have_content 'Descrição: Esse projeto é sobre a criação de um website para a cidade'
    expect(page).to have_content 'Categoria: Webdesign'
    expect(page).to have_content 'Título: Peça de Teatro'
    expect(page).to have_content 'Descrição: Espetáculo de Shakespeare'
    expect(page).to have_content 'Categoria: Teatro'
  end

  it 'e não existe nenhum projeto cadastrado' do
    deco = create :user, email: 'deco@email.com'

    login_as deco
    visit projects_path

    expect(page).to have_content 'Projetos'
    expect(page).to have_content 'Não existem projetos cadastrados.'
  end

  it 'que criou e deve estar autenticado' do
    visit my_projects_projects_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'e vê apenas os projetos que criou' do
    deco = create :user, email: 'deco@email.com'
    mateus = create :user, email: 'mateus@email.com', cpf: '096.505.460-81'
    create :project, user: deco, title: 'Padrão', description: 'Descrição de um projeto padrão para testes',
                     category: 'Teste'
    create :project, title: 'Criação de site',
                     description: 'Esse projeto é sobre a criação de um website para a cidade',
                     category: 'Webdesign', user: deco
    create :project, title: 'Peça de Teatro', description: 'Espetáculo de Shakespeare', category: 'Teatro', user: mateus

    login_as deco
    visit projects_path
    click_on 'Meus Projetos'

    expect(current_path).to eq my_projects_projects_path
    expect(page).to have_content 'Título: Padrão'
    expect(page).to have_content 'Descrição: Descrição de um projeto padrão para testes'
    expect(page).to have_content 'Categoria: Teste'
    expect(page).to have_content 'Título: Criação de site'
    expect(page).to have_content 'Descrição: Esse projeto é sobre a criação de um website para a cidade'
    expect(page).to have_content 'Categoria: Webdesign'
    expect(page).not_to have_content 'Título: Peça de Teatro'
    expect(page).not_to have_content 'Descrição: Espetáculo de Shakespeare'
    expect(page).not_to have_content 'Categoria: Teatro'
  end

  it 'e não criou nenhum projeto' do
    deco = create :user, email: 'deco@email.com'
    mateus = create :user, email: 'mateus@email.com', cpf: '096.505.460-81'
    create :project, user: deco, title: 'Padrão', description: 'Descrição de um projeto padrão para testes',
                     category: 'Teste'
    create :project, title: 'Criação de site',
                     description: 'Esse projeto é sobre a criação de um website para a cidade',
                     category: 'Webdesign', user: deco

    login_as mateus
    visit my_projects_projects_path

    expect(page).to have_content 'Não existem projetos cadastrados.'
    expect(page).not_to have_content 'Título: Padrão'
    expect(page).not_to have_content 'Descrição: Descrição de um projeto padrão para testes'
    expect(page).not_to have_content 'Categoria: Teste'
    expect(page).not_to have_content 'Título: Criação de site'
    expect(page).not_to have_content 'Descrição: Esse projeto é sobre a criação de um website para a cidade'
    expect(page).not_to have_content 'Categoria: Webdesign'
  end
end
