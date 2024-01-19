require 'rails_helper'

describe 'Usuário faz logout' do
  it 'com sucesso' do
    user = create(:user)

    login_as user, scope: :user
    visit root_path
    click_on 'Sair'

    within 'nav' do
      expect(page).to have_content 'Entrar'
      expect(page).not_to have_content user.email
      expect(page).not_to have_content 'Sair'
    end
    expect(page).to have_content 'Logout efetuado com sucesso.'
  end
end
