require 'rails_helper'

describe 'Usuário edita projeto' do
  it 'a partir de detalhes de um projeto' do
    user = create(:user)
    project = create(:project, user:, title: 'Projeto Original', description: 'Projeto para testar a edição.')

    create(:project_job_category, project:, job_category_id: 1)
    create(:project_job_category, project:, job_category_id: 2)

    job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor'),
                      JobCategory.new(id: 2, name: 'RH')]

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    login_as(user)
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Original'
    click_on 'Editar Projeto'

    expect(page).to have_current_path edit_project_path(project)
    expect(page).to have_checked_field 'Desenvolvedor'
    expect(page).to have_checked_field 'RH'
    expect(page).to have_field 'Título', with: 'Projeto Original'
    expect(page).to have_field 'Descrição', with: 'Projeto para testar a edição.'
  end

  it 'com sucesso' do
    user = create(:user)
    project = create(:project, user:, title: 'Projeto Original', description: 'Projeto para testar a edição.')

    create(:project_job_category, project:, job_category_id: 1)
    create(:project_job_category, project:, job_category_id: 2)

    job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor'),
                      JobCategory.new(id: 2, name: 'RH')]

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0])

    login_as(user)
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Original'
    click_on 'Editar Projeto'
    fill_in 'Título', with: 'Projeto editado'
    fill_in 'Descrição', with: 'Edição realizada'
    uncheck 'RH'
    click_on 'Salvar'

    expect(page).to have_content 'Projeto editado com sucesso!'
    expect(page).to have_content 'Projeto editado'
    expect(page).to have_content 'Edição realizada'
    expect(page).to have_content 'Desenvolvedor'
    expect(page).not_to have_content 'RH'
    expect(project.project_job_categories.count).to eq 1
    expect(page).to have_current_path project_path(project)
  end

  it 'e usuário deixa campos em branco' do
    user = create(:user)
    project = create(:project, user:, title: 'Projeto Original', description: 'Projeto para testar a edição.')

    create(:project_job_category, project:, job_category_id: 1)
    create(:project_job_category, project:, job_category_id: 2)

    job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor'),
                      JobCategory.new(id: 2, name: 'RH')]

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    login_as user, scope: :user
    visit edit_project_path(project)
    fill_in 'Título', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Categoria', with: ''
    uncheck 'Desenvolvedor'
    click_on 'Salvar Projeto'

    expect(page).to have_content 'Não foi possível editar o projeto.'
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Categoria não pode ficar em branco'
    expect(page).to have_unchecked_field 'Desenvolvedor'
    expect(page).to have_checked_field 'RH'
    expect(page).to have_current_path edit_project_path(project)
  end

  it 'e não é o lider do projeto' do
  end
end
