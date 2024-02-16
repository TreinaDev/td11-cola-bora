require 'rails_helper'

describe 'Usuário edita projeto' do
  it 'a partir de detalhes de um projeto' do
    user = create(:user)
    project = create(:project, user:, title: 'Projeto Original', description: 'Projeto para testar a edição.')

    create(:project_job_category, project:, job_category_id: 1)
    create(:project_job_category, project:, job_category_id: 2)

    job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor'),
                      JobCategory.new(id: 2, name: 'RH')]

    allow(JobCategory).to receive(:all).and_return(job_categories).exactly(2).times

    allow(JobCategory).to receive(:find).with(1).and_return(job_categories[0]).exactly(2).times
    allow(JobCategory).to receive(:find).with(2).and_return(job_categories[1]).exactly(2).times

    login_as(user)
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Original'
    click_on 'Editar'

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

    allow(JobCategory).to receive(:all).and_return(job_categories).exactly(3).times

    allow(JobCategory).to receive(:find).with(1).and_return(job_categories[0]).exactly(3).times
    allow(JobCategory).to receive(:find).with(2).and_return(job_categories[1]).exactly(2).times

    login_as(user)
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Original'
    click_on 'Editar'
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

    allow(JobCategory).to receive(:all).and_return(job_categories).exactly(2).times

    allow(JobCategory).to receive(:find).with(1).and_return(job_categories[0]).exactly(2).times
    allow(JobCategory).to receive(:find).with(2).and_return(job_categories[1]).exactly(2).times

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
    user = create(:user)
    project = create(:project, user:, title: 'Projeto Original', description: 'Projeto para testar a edição.')

    other_user = create(:user, cpf: '32823816038')
    create(:user_role, project:, role: :admin, user: other_user)

    login_as other_user
    visit project_path(project)

    expect(page).not_to have_link 'Editar Projeto'
  end

  it 'duas vezes alterando check box' do
    user = create(:user)
    project = create(:project, user:, title: 'Projeto Original', description: 'Projeto para testar a edição.')

    create(:project_job_category, project:, job_category_id: 1)
    create(:project_job_category, project:, job_category_id: 2)

    job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor'),
                      JobCategory.new(id: 2, name: 'RH')]

    allow(JobCategory).to receive(:all).and_return(job_categories).exactly(4).times

    allow(JobCategory).to receive(:find).with(1).and_return(job_categories[0]).exactly(3).times
    allow(JobCategory).to receive(:find).with(2).and_return(job_categories[1]).exactly(2).times

    login_as(user)
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Original'
    click_on 'Editar'
    fill_in 'Título', with: 'Projeto editado'
    fill_in 'Descrição', with: 'Edição realizada'
    uncheck 'RH'
    click_on 'Salvar'
    click_on 'Editar'
    fill_in 'Título', with: 'Projeto editado 2x'
    fill_in 'Descrição', with: 'Edição realizada 2x'
    check 'RH'
    click_on 'Salvar'

    expect(JobCategory).to have_received(:all).with(no_args).exactly(4).times
    expect(JobCategory).to have_received(:find).with(1).exactly(3).times
    expect(JobCategory).to have_received(:find).with(2).exactly(2).times

    expect(page).to have_content 'Projeto editado com sucesso!'
    expect(page).to have_content 'Projeto editado 2x'
    expect(page).to have_content 'Edição realizada 2x'
    expect(page).to have_content 'Desenvolvedor'
    expect(page).to have_content 'RH'
    expect(project.project_job_categories.count).to eq 2
    expect(page).to have_current_path project_path(project)
  end
end
