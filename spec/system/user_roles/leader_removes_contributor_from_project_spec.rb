require 'rails_helper'

describe 'Líder de projeto remove colaborador' do
  it 'com sucesso' do
    leader = create :user
    project = create :project, user: leader
    contributor1 = create :user, cpf: '528.128.410-01', email: 'removido@email.com'
    contributor_1_role = create :user_role, project:, user: contributor1, role: :contributor
    contributor2 = create :user, cpf: '346.045.150-50', email: 'sobrevivente@email.com'
    contributor_2_role = create :user_role, project:, user: contributor2, role: :contributor

    login_as leader, scope: :user
    visit edit_project_user_role_path project, contributor_1_role
    accept_confirm('Deseja remover este colaborador?') { click_on 'Remover' }

    expect(page).to have_current_path members_project_path(project)
    within 'table' do
      expect(page).not_to have_content 'removido@email.com'
      expect(page).to have_content 'sobrevivente@email.com'
    end
    expect(page).to have_content 'Colaborador removido com sucesso'
    expect(project.member_roles(:contributor)).not_to include contributor_1_role
    expect(project.member_roles(:contributor)).to include contributor_2_role
  end
end
