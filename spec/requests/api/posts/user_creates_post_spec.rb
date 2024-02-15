require 'rails_helper'

describe 'Usuário cria postagem' do
  it 'e é colaborador' do
    user = create(:user)
    project = create(:project, user:)

    login_as user, scope: :user
    post api_v1_project_posts_path(project),
         params: { post: { title: 'Postagem inicial', body: 'Vamos abordar boas práticas' } }

    expect(Post.count).to eq 1
    expect(Post.last.title).to eq 'Postagem inicial'
    expect(Post.last.body).to eq 'Vamos abordar boas práticas'
  end

  it 'e não é colaborador' do
    user = create(:user)
    project = create(:project, user:)
    not_colaborator = create(:user, cpf: '670.547.300-20')
    create(:project, user: not_colaborator)

    login_as not_colaborator, scope: :user
    post api_v1_project_posts_path(project),
         params: { post: { title: 'Postagem inicial', body: 'Vamos abordar boas práticas' } }

    expect(Post.count).to eq 0
    expect(response).to have_http_status :forbidden
    json_response = JSON.parse(response.body)
    expect(json_response['error']).to eq 'Você não possui permissão.'
  end
end
