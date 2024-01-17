require 'rails_helper'

describe 'Visitante acessa página de criação de conta' do
  it 'a partir da página inicial' do
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta'

    expect(page).to have_field 'CPF'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
    expect(page).to have_button 'Criar conta'
  end

  it 'e cria uma conta com sucesso' do
    visit new_user_registration_path
    fill_in 'CPF', with: '803.750.960-51'
    fill_in 'E-mail', with: 'usuario@email.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Criar conta'

    within 'nav' do
      expect(page).to have_content 'usuario@email.com'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_link 'Entrar'
    end
    expect(User.count).to eq 1
    expect(User.last.cpf).to eq '803.750.960-51'
    expect(User.last.email).to eq 'usuario@email.com'
    expect(User.last.profile).to be_present
  end

  it 'e não cria uma conta com campos vazios' do
    visit new_user_registration_path
    fill_in 'CPF', with: '123456789'
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Criar conta'

    expect(page).to have_content 'CPF inválido'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(User.all).to be_empty
  end
end
