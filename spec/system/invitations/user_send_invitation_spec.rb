require 'rails_helper'

describe 'Usuário quer enviar convite' do
  it 'a partir do perfil do usuário da Portfoliorrr' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')
    create(:project, user:, title: 'Segundo projeto')

    json = File.read(Rails.root.join('spec/support/json/portfoliorrr_profile.json'))

    fake_response = double('faraday_response', status: 200, body: json)
    id = JSON.parse(fake_response.body)['id']
    url = "https://e07813cd-df3d-4023-920b-4037df5a0c31.mock.pstmn.io/profiles/#{id}"
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)

    login_as user
    visit portfoliorrr_profile_path(id)
    fill_in 'Prazo de validade (em dias)', with: 10
    select 'Meu novo projeto', from: 'Projetos'
    click_on 'Enviar convite'

    expect(page).to have_content 'Convite enviado com sucesso!'
  end

  it 'mas o usuário da Portfoliorrr já foi convidado para o projeto' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    json = File.read(Rails.root.join('spec/support/json/portfoliorrr_profile.json'))

    fake_response = double('faraday_response', status: 200, body: json)
    id = JSON.parse(fake_response.body)['id']
    url = "https://e07813cd-df3d-4023-920b-4037df5a0c31.mock.pstmn.io/profiles/#{id}"
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)

    Invitation.create!(expiration_days: 10, project:, profile_id: 1)

    login_as user
    visit portfoliorrr_profile_path(id)
    fill_in 'Prazo de validade (em dias)', with: 10
    select 'Meu novo projeto', from: 'Projetos'
    click_on 'Enviar convite'

    expect(page).to have_content 'Esse usuário possui convite pendente'
    expect(project.invitations.count).to eq 1
  end
end
