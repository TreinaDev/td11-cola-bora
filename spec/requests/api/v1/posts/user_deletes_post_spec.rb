require 'rails_helper'

describe 'Usuário apaga a postagem' do
  it 'e é colaborador' do
    user = create(:user)
    project = create(:project, user:)
    post = create(:post, user_role: user.user_roles.first, project:)

    login_as user, scope: :user
    delete api_v1_project_post_path(project, post)

    expect(Post.count).to eq 0
    expect(page).to have_content 'Postagem apagada com sucesso.'
  end
end
