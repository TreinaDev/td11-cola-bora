require 'rails_helper'

describe 'Usuário visualiza comentário de publicação no Fórum' do
  it 'a partir da tela inicial' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader, title: 'Projeto Top'
    leader_role = UserRole.last
    post = create :post, user_role: leader_role, project:, title: 'Post Top'
    create :comment, user_role: leader_role, post:, content: 'Comentário top'

    login_as leader
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Top'
    click_on 'Fórum'
    click_on 'Post Top'

    expect(page).to have_content 'Comentários'
    expect(page).to have_content 'Comentário top'
    expect(page).to have_content "Autor: #{leader.full_name}"
  end
end
