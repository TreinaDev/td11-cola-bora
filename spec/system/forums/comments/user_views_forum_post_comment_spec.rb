require 'rails_helper'

describe 'Usuário visualiza comentário de publicação no Fórum' do
  include ActionView::Helpers::DateHelper
  it 'a partir da tela inicial' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader, title: 'Projeto Top'
    leader_role = UserRole.last
    post = create :post, user_role: leader_role, project:, title: 'Post Top'
    comment = create :comment, user_role: leader_role, post:, content: 'Comentário top'

    login_as leader
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Top'
    click_on 'Fórum'
    click_on 'Post Top'

    expect(page).to have_content 'Comentários:'
    expect(page).to have_content 'Comentário top'
    expect(page).to have_content "por #{leader.full_name}"
    expect(page).to have_content "Postado há #{time_ago_in_words comment.created_at}"
  end

  it 'e não tem nenhum comentário' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader, title: 'Projeto Top'
    leader_role = UserRole.last
    create :post, user_role: leader_role, project:, title: 'Post Top'

    login_as leader
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Top'
    click_on 'Fórum'
    click_on 'Post Top'

    expect(page).to have_content 'Comentários:'
    expect(page).to have_content 'Seja o primeiro a comentar'
    expect(page).to have_button 'Comentar'
    expect(page).to have_field 'Conteúdo:'
  end

  it 'e não vê comentários de outros posts' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader, title: 'Projeto Top'
    leader_role = UserRole.last
    post_one = create :post, user_role: leader_role, project:, title: 'Post Top'
    create :comment, user_role: leader_role, post: post_one, content: 'Comentário top'
    create :post, user_role: leader_role, project:, title: 'Melhor Post'

    login_as leader
    visit project_forum_path project
    click_on 'Melhor Post'

    expect(page).not_to have_content 'Comentário top'
  end
end
