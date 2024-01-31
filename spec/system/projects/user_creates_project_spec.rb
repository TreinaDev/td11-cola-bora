require 'rails_helper'

describe 'Usuário cria um projeto' do
  it 'e deve estar autenticado' do
    visit new_project_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'a partir da home com sucesso' do
    user = create :user, email: 'usuario@email.com'
    create(:profile, user:)
    job_categories = [JobCategory.new(id: 1, name: 'Editor de Video'),
                      JobCategory.new(id: 2, name: 'Editor de Imagem'),
                      JobCategory.new(id: 3, name: 'Desenvolvedor')]

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    login_as(user)
    visit(root_path)
    click_on 'Criar Projeto'
    fill_in 'Título', with: 'Mewtwo'
    fill_in 'Descrição', with: 'Um projeto para criar o pokémon mais poderoso.'
    fill_in 'Categoria', with: 'Jogo'
    within '#project_job_category' do
      check 'Editor de Video'
      check 'Editor de Imagem'
    end
    click_on 'Salvar Projeto'

    expect(page).to have_content 'Projeto: Mewtwo'
    expect(page).to have_content "Autor: #{user.email}"
    expect(page).to have_content 'Um projeto para criar o pokémon mais poderoso.'
    expect(page).to have_content 'Jogo'
    expect(page).to have_content 'Editor de Video'
    expect(page).to have_content 'Editor de Imagem'
    expect(page).not_to have_content 'Desenvolvedor'
    expect(page).to have_content 'Projeto criado com sucesso.'
    project = Project.last
    author = project.user_roles.first
    expect(author.leader?).to be true
    expect(project.project_job_categories.count).to eq 2
  end

  it 'com campos vazios' do
    user = create :user
    create(:profile, user:)

    login_as(user)
    visit(new_project_path)
    fill_in 'Título', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Categoria', with: ''
    click_on 'Salvar Projeto'

    expect(current_path).to eq new_project_path
    expect(page).to have_content 'Não foi possível criar o projeto.'
    expect(page).to have_content 'Erros:'
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Categoria não pode ficar em branco'
  end

  xit 'e não há retorno de categorias de trabalho da api' do
    user = create :user, email: 'usuario@email.com'

    login_as(user)
    visit(new_project_path)

    expect(page).to have_content 'Sem categorias de trabalho para adicionar, retorne depois.'
  end
end
