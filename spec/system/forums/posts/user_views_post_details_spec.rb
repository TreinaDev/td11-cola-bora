require 'rails_helper'

describe 'Usuário visualiza post do fórum' do
  it 'com sucesso e não vê outros posts' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader, title: 'Projeto Top'
    leader_role = UserRole.last
    create :post, user_role: leader_role, project:, title: 'Post Top',
                  body: 'Estive desenvolvendo um método top'
    create :post, user_role: leader_role, project:, title: 'Melhor Post',
                  body: 'Estive desenvolvendo um método melhor ainda'

    login_as leader
    visit project_forum_path project
    click_on 'Melhor Post'

    expect(page).to have_content 'Melhor Post'
    expect(page).to have_content 'Estive desenvolvendo um método melhor ainda'
    expect(page).not_to have_content 'Post Top'
    expect(page).not_to have_content 'Estive desenvolvendo um método top'
    expect(page).to have_button 'Voltar'
  end
end
