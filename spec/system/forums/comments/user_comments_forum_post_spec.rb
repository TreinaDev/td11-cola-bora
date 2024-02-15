require 'rails_helper'

describe 'Usuário comenta em post do fórum' do
  it 'com sucesso', js: true do
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
    fill_in 'Conteúdo:', with: 'Muito boa sugestão!!'
    click_on 'Comentar'

    expect(page).not_to have_content 'Seja o primeiro a comentar'
    expect(page).to have_content 'Muito boa sugestão!!'
    expect(page).to have_content "por #{leader.full_name}"
    expect(page).to have_content "Postado em #{time_ago_in_words(Comment.last.created_at)}"
    expect(Comment.count).to eq 1
  end

  xit 'com campo em branco'
end
