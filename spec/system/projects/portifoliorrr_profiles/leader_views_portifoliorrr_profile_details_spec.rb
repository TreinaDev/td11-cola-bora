require 'rails_helper'

describe 'Líder de projeto vê detalhes de um perfil da Portifoliorrr' do
  it 'com sucesso a partir da home' do
    user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
    project = create :project, user:, title: 'Projeto Top'
    project.user_roles.find_by(user:).update(role: :leader)
    url = 'http://localhost:8000/api/v1/users'
    json = File.read(Rails.root.join('spec/support/portifoliorrr_profiles_data.json'))
    fake_response = double 'faraday_response', status: 200, body: json, success?: true
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)
    profile_id = 3
    url = "http://localhost:8000/api/v1/users/#{profile_id}"
    json = File.read(Rails.root.join('spec/support/portifoliorrr_profile_details_data.json'))
    fake_response = double 'faraday_response', status: 200, body: json, success?: true
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)

    login_as user
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Top'
    click_on 'Procurar usuários'
    click_on 'Rodolfo'

    expect(current_path).to eq project_portifoliorrr_profile project, profile_id
    expect(page).to have_content 'Perfil de Rodolfo'
    expect(page).to have_content 'Email: rodolfo@email.com'
    expect(page).to have_content 'Tipo de Serviço: Editor de Vídeo'
    expect(page).to have_content 'Descrição: Canal do Youtube'
    expect(page).to have_content 'Sobre mim: Me chamo Rodolfo e sou editor de vídeos em um canal do Youtube.'
  end

  xit 'e retorna erro interno'

  xit 'e não consegue se conectar com a API'

  xit 'teste de request id não existe, não é líder'
end
