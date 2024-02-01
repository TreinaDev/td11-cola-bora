require 'rails_helper'

describe 'Usuário deleta projeto' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, title: 'Projeto teste', user:)

    job_categories = [JobCategory.new(id: 1, name: 'Editor de Video'),
                      JobCategory.new(id: 2, name: 'Editor de Imagem')]

    allow(JobCategory).to receive(:all).and_return(job_categories)

    allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])

    create(:project_job_category, project:, job_category_id: 1)
    create(:project_job_category, project:, job_category_id: 2)

    login_as user, scope: :user
    visit edit_project_path project
    accept_confirm('Deletar projeto?') { click_on 'Deletar' }

    expect(page).to have_current_path projects_path
    expect(Project.all).to be_empty
    expect(ProjectJobCategory.all).to be_empty
    expect(page).to have_content 'Projeto deletado com sucesso!'
    expect(page).not_to have_content 'Projeto teste'
  end

  it 'e cancela deleção' do
    user = create(:user)
    project = create(:project, title: 'Projeto teste', user:)

    login_as user, scope: :user
    visit edit_project_path project
    dismiss_confirm('Deletar projeto?') { click_on 'Deletar' }

    expect(page).to have_current_path edit_project_path(project)
    expect(Project.count).to eq 1
    expect(page).not_to have_content 'Projeto deletado com sucesso!'
  end
end
