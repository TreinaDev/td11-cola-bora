require 'rails_helper'

describe 'Usuário cria comentário em postagem do fórum' do
  it 'com sucesso' do
    project = create :project
    post_author = create :user, cpf: '149.723.680-04', email: 'post_author@email.com'
    post_author_role = create :user_role, project:, user: post_author, role: :contributor
    post = create :post, project:, user_role: post_author_role
    comment_author = create :user, cpf: '498.494.550-80', email: 'comment_author@email.com'
    create :user_role, project:, user: comment_author, role: :admin
    params = { comment: { content: 'Muito bom!!' } }

    login_as comment_author
    post post_comments_path(post, params:)

    expect(response).to have_http_status :created
    expect(response.content_type).to include 'application/json'
    expect(Comment.count).to eq 1
    json_response = JSON.parse response.body
    expect(json_response['content']).to eq 'Muito bom!!'
    expect(json_response['author']).to eq 'comment_author'
  end

  it 'e não está autenticado' do
    project = create :project
    post_author = create :user, cpf: '149.723.680-04', email: 'post_author@email.com'
    post_author_role = create :user_role, project:, user: post_author, role: :contributor
    post = create :post, project:, user_role: post_author_role

    post post_comments_path(post, params: '')

    expect(response).to redirect_to new_user_session_path
  end

  it 'sem conteúdo' do
    project = create :project
    post_author = create :user, cpf: '149.723.680-04', email: 'post_author@email.com'
    post_author_role = create :user_role, project:, user: post_author, role: :contributor
    post = create :post, project:, user_role: post_author_role
    comment_author = create :user, cpf: '498.494.550-80', email: 'comment_author@email.com'
    create :user_role, project:, user: comment_author, role: :admin
    params = { comment: { content: '' } }

    login_as comment_author
    post post_comments_path(post, params:)

    expect(response).to have_http_status :unprocessable_entity
    expect(Comment.count).to eq 0
  end

  it 'e não faz parte do projeto' do
    project = create :project
    post_author = create :user, cpf: '149.723.680-04', email: 'post_author@email.com'
    post_author_role = create :user_role, project:, user: post_author, role: :contributor
    post = create :post, project:, user_role: post_author_role
    non_member = create :user, cpf: '498.494.550-80'
    params = { comment: { content: 'Péssimo post!' } }

    login_as non_member
    post post_comments_path(post, params:)

    expect(response).to have_http_status :unauthorized
    expect(Comment.count).to eq 0
  end
end
