require 'rails_helper'

describe 'Usuário edita perfil' do
  it 'a partir da tela inicial' do
    user = create(:user)
    create(:profile, user:)

    login_as user, scope: :user
    visit root_path
    click_on 'Meu perfil'
    click_on 'Editar'

    expect(page).to have_content 'Editar Perfil'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'Experiência profissional'
    expect(page).to have_field 'Informação acadêmica'
    expect(page).to have_button 'Salvar Perfil'
  end

  xit 'com sucesso'
  xit 'deixa campo vazio'
  xit 'não é o dono do perfil'
  xit 'não está autenticado'
end
