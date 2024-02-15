require 'rails_helper'

describe 'Usuário edita postagem' do
  it 'e é contribuinte autor da postagem' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    post = create(:post, project:, user_role: contributor_role, title: 'Postagem inicial')

    login_as contributor, scope: :user
    patch(project_post_path(project, post), params: { post: { title: 'Postagem divertida' } })

    expect(response).to redirect_to project_p_path(project, post)
    expect(post.reload.title).to eq 'Postagem divertida'
  end

  it 'e é contribuinte do projeto não autor da postagem' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    project.user_roles.create!(user: contributor, role: :contributor)
    post = create(:post, project:, user_role: leader.user_roles.first, title: 'Primeira postagem')

    login_as contributor, scope: :user
    patch(project_post_path(project, post), params: { post: { title: 'Segunda postagem' } })

    expect(post.reload.title).to eq 'Primeira postagem'
    expect(response).to redirect_to project_project_path(project)
  end

  it 'e é um líder não autor da postagem' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    post = create(:post, project:, user_role: contributor_role, title: 'Postagem inicial')

    login_as leader, scope: :user
    patch(project_post_path(project, post), params: { post: { title: 'Postagem divertida' } })

    expect(post.reload.title).to eq 'Postagem divertida'
    expect(response).to redirect_to project_forum_path(project, post)
  end

  it 'e é um administrador não autor da postagem' do
    leader = create(:user)
    project = create(:project, user: leader)
    admin = create(:user, email: 'admin@email.com', cpf: '000.000.001-91')
    project.user_roles.create!(user: admin, role: :admin)
    post = create(:post, project:, user_role: leader.user_roles.first, title: 'Postagem inicial')

    login_as admin, scope: :user
    patch(project_post_path(project, post), params: { post: { title: 'Postagem divertida' } })

    expect(post.reload.title).to eq 'Postagem divertida'
    expect(response).to redirect_to project_forum_path(project)
  end
end
