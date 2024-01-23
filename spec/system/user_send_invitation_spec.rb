require 'rails_helper'

describe 'Usuário envia convite' do
  it 'a partir do perfil do usuário da Portfoliorrr' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')
    other_project = create(:project, user:, title: 'Segundo projeto')

    json = File.read(Rails.root.join('spec/support/json/portfoliorrr_profile.json'))

    fake_response = double('faraday_response', status: 200, body: json)
    id = JSON.parse(fake_response.body)['id']
    url = "http://localhost:3001/api/v1/profiles/#{id}"
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)

    login_as user
    visit portfoliorrr_profile_path(id)
    fill_in 'Vencimento', with: 10.days.from_now.to_date
    select 'Meu novo projeto', from: 'Projetos'
    click_on 'Enviar convite'

    expect(page).to have_content 'Convite enviado com sucesso!'
    expect(page).not_to have_field 'Vencimento'
    expect(page).not_to have_button 'Enviar convite'
    expect(page).to have_content 'Esse usuário possui convite pendente'
  end
end
