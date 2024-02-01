require 'rails_helper'

describe 'Usuário vê detalhes do projeto' do
  it 'A partir da home' do
    deco = create :user, email: 'deco@email.com'
    create :project, user: deco, title: 'Padrão', description: 'Descrição de um projeto padrão para testes',
                     category: 'Teste'
    project = create :project, title: 'Criação de site',
                               description: 'Esse projeto é sobre a criação de um website para a cidade',
                               category: 'Webdesign', user: deco

    job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor'),
                      JobCategory.new(id: 2, name: 'RH')]

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    create(:project_job_category, project:, job_category_id: 1)
    create(:project_job_category, project:, job_category_id: 2)

    login_as deco
    visit root_path
    click_on 'Projetos'
    click_on 'Criação de site'

    expect(page).to have_content 'Projeto: Criação de site'
    expect(page).to have_content 'Autor: deco@email.com'
    expect(page).to have_content 'Descrição: Esse projeto é sobre a criação de um website para a cidade'
    expect(page).to have_content 'Categoria: Webdesign'
    expect(page).not_to have_content 'Título: Padrão'
    expect(page).not_to have_content 'Descrição: Descrição de um projeto padrão para testes'
    expect(page).not_to have_content 'Categoria: Teste'
    expect(page).to have_content "Categorias de trabalho\nDesenvolvedor\nRH"
    expect(current_path).to eq project_path(project)
  end

  it 'e projeto tem apenas uma categoria de trabalho' do
    job_category = create(:project_job_category, job_category_id: 1)
    user = job_category.project.user
    project = job_category.project

    job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor'),
                      JobCategory.new(id: 2, name: 'RH')]

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    login_as user, scope: :user
    visit project_path(project)

    expect(page).to have_content 'Categoria de trabalho'
    expect(page).to have_content 'Desenvolvedor'
  end

  it 'e não tem nenhuma categoria de trabalho' do
    user = create :user
    project = create(:project, user:)

    login_as user, scope: :user
    visit project_path(project)

    expect(page).not_to have_content 'Categoria de trabalho'
    expect(page).not_to have_content 'Categorias de trabalho'
    expect(page).to have_content 'Ainda não há categoria de trabalho'
  end

  it 'e não encontra a api' do
    job_category = create(:project_job_category, job_category_id: 1)
    user = job_category.project.user
    project = job_category.project

    login_as user, scope: :user
    visit project_path(project)

    expect(page).to have_content 'Categoria de trabalho está indisponível temporariamente'
    expect(page).to have_current_path project_path(project)
  end

  it 'e deve estar autenticado' do
    deco = create :user, email: 'deco@email.com'
    project = create :project, user: deco, title: 'Padrão', description: 'Descrição de um projeto padrão para testes',
                               category: 'Teste'

    create(:project_job_category, project:)

    visit project_path(project)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
    expect(page).not_to have_content 'Projeto: Padrão'
    expect(page).not_to have_content 'Autor: deco@email.com'
    expect(page).not_to have_content 'Descrição: Descrição de um projeto padrão para testes'
    expect(page).not_to have_content 'Categoria: Teste'
    expect(page).not_to have_content "Categoria de Trabalho\nDesenvolvedor"
  end

  it 'que não existe' do
    deco = create :user, email: 'deco@email.com'

    login_as deco
    visit project_path('999')

    expect(current_path).to eq root_path
    expect(page).to have_content 'Projeto não encontrado.'
  end
end
