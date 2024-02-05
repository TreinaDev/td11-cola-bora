require 'rails_helper'

describe 'Usuário vê projetos' do
  it 'a partir da home com sucesso' do
    leader = create :user
    other_leader = create :user, cpf: '096.505.460-81'
    project_one = create :project, user: other_leader, title: 'Capturar todos os pokemons',
                                   description: 'Descrição do projeto 1', category: 'Categoria 1'
    project_two = create :project, user: other_leader, title: 'Mestre pokemon',
                                   description: 'Esse projeto é o mais dificil', category: 'Categoria 2'
    create :project, user: leader, title: 'Pokedex',
                     description: 'Projeto interessante!', category: 'Categoria 3'
    create :project, user: leader, title: 'Pegar um mewtwo',
                     description: 'Projeto top!', category: 'Categoria 5'
    create :user_role, project: project_one, user: leader, role: :contributor
    create :user_role, project: project_two, user: leader, role: :admin

    login_as leader
    visit projects_path

    expect(page).to have_content 'Projetos'
    expect(page).not_to have_content 'Nenhum projeto.'
    expect(page).to have_content 'Capturar todos os pokemons'
    expect(page).to have_content 'Descrição do projeto 1'
    expect(page).to have_content 'Categoria: Categoria 1'
    expect(page).to have_content 'Mestre pokemon'
    expect(page).to have_content 'Esse projeto é o mais dificil'
    expect(page).to have_content 'Categoria: Categoria 2'
    expect(page).to have_content 'Pokedex'
    expect(page).to have_content 'Projeto interessante!'
    expect(page).to have_content 'Categoria: Categoria 3'
  end

  it 'e não existe nenhum projeto cadastrado' do
    user = create :user

    login_as user
    visit projects_path

    expect(page).to have_content 'Projetos'
    expect(page).to have_content 'Nenhum projeto.'
  end

  it 'nos quais é lider' do
    leader = create :user
    other_leader = create :user, cpf: '096.505.460-81'
    create :project, user: other_leader, title: 'Capturar todos os pokemons',
                     description: 'Descrição do projeto 1', category: 'Categoria 1'
    create :project, user: leader, title: 'Mestre pokemon',
                     description: 'Esse projeto é o mais dificil', category: 'Categoria 2'
    create :project, user: leader, title: 'Pokedex',
                     description: 'Projeto interessante!', category: 'Categoria 3'

    login_as leader
    visit projects_path
    click_on 'Meus projetos'

    expect(page).to have_content 'Projetos'
    expect(page).not_to have_content 'Nenhum projeto.'
    expect(page).not_to have_content 'Capturar todos os pokemons'
    expect(page).to have_content 'Mestre pokemon'
    expect(page).to have_content 'Esse projeto é o mais dificil'
    expect(page).to have_content 'Categoria: Categoria 2'
    expect(page).to have_content 'Pokedex'
    expect(page).to have_content 'Projeto interessante!'
    expect(page).to have_content 'Categoria: Categoria 3'
  end

  it 'nos quais é lider e não há nenhum projeto' do
    leader = create :user
    other_leader = create :user, cpf: '096.505.460-81'
    create :project, user: other_leader, title: 'Capturar todos os pokemons'
    create :project, user: other_leader, title: 'Mestre pokemon'

    login_as leader
    visit projects_path
    click_on 'Meus projetos'

    expect(page).to have_content 'Projetos'
    expect(page).to have_content 'Nenhum projeto.'
    expect(page).not_to have_content 'Capturar todos os pokemons'
    expect(page).not_to have_content 'Mestre pokemon'
  end

  it 'nos quais é colaborador' do
    leader = create :user
    contributor = create :user, email: 'contributor@email.com', cpf: '096.505.460-81'
    project_one = create :project, user: leader, title: 'Capturar todos os pokemons',
                                   description: 'Descrição do projeto 1', category: 'Categoria 1'
    project_two = create :project, user: leader, title: 'Mestre pokemon',
                                   description: 'Esse projeto é o mais dificil', category: 'Categoria 2'
    create :user_role, project: project_one, user: contributor, role: :contributor
    create :user_role, project: project_two, user: contributor, role: :contributor

    login_as contributor
    visit projects_path
    click_on 'Projetos que colaboro'

    expect(page).to have_content 'Projetos'
    expect(page).not_to have_content 'Nenhum projeto.'
    expect(page).to have_content 'Capturar todos os pokemons'
    expect(page).to have_content 'Descrição do projeto 1'
    expect(page).to have_content 'Categoria: Categoria 1'
    expect(page).to have_content 'Mestre pokemon'
    expect(page).to have_content 'Esse projeto é o mais dificil'
    expect(page).to have_content 'Categoria: Categoria 2'
  end

  it 'nos quais é colaborador e não há nenhum projeto' do
    leader = create :user
    contributor = create :user, cpf: '643.770.760-78'
    project_one = create :project, user: leader, title: 'Capturar todos os pokemons'
    create :user_role, project: project_one, user: contributor, role: :contributor
    not_contributor = create :user, cpf: '096.505.460-81'

    login_as not_contributor
    visit projects_path
    click_on 'Projetos que colaboro'

    expect(page).to have_content 'Nenhum projeto.'
    expect(page).not_to have_content 'Capturar todos os pokemons'
  end
end
