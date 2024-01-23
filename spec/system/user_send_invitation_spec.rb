require 'rails_helper'

describe 'Usuário envia convite' do
  it 'a partir do perfil do usuário da Portfoliorrr' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    json = [
      {
        full_name: 'Pedro Barbosa',
        email: 'pedrobarbosa@mail.com'
      },
      {
        full_name: 'João Mendes',
        email: 'joaomendes@mail.com'
      }
    ]

    url = 'http://localhost:3001/api/v1/search?query=desenvolvimento+web'
    fake_response = double('faraday_response', status: 200, body: json)
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)

    login_as user
    visit 'search_results?result=1'
    fill_in 'Vencimento', with: 10.days.from_now
    click_on 'Enviar convite'

    expect(page).to have_content 'Convite enviado com sucesso!'
    expect(page).not_to have_field 'Vencimento'
    expect(page).not_to have_button 'Enviar convite'
    expect(page).to have_content 'Esse usuário possui convite pendente'
  end
end
