require 'rails_helper'

describe 'Usuário edita projeto' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, user:, title: 'Projeto Original', description: 'Projeto para testar a edição.')

    project_job_category = create(:project_job_category, project:, job_category_id: 1)
    project_job_category = create(:project_job_category, project:, job_category_id: 2)

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

    expect(page).to have_current_path edit_project_path(project)
    expect(page).to have_content 'Projeto editado com sucesso!'
    expect(page).to have_content 'Projeto editado'
    expect(page).to have_content 'Edição realizada'
    expect(page).to have_content 'Desenvolvedor'
    expect(page).not_to have_content 'RH'
    expect(project.project_job_categories.count).to eq 1
  end
end
