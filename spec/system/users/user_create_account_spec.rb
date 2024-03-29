require 'rails_helper'

describe 'Visitante acessa página de criação de conta' do
  it 'e cria uma conta com sucesso' do
    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    click_on 'Criar conta'
    fill_in 'CPF', with: '803.750.960-51'
    fill_in 'E-mail', with: 'usuario@email.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Criar conta'

    expect(page).to have_current_path edit_profile_path(User.last.profile)
    expect(page).to have_content 'Você realizou seu registro com sucesso.'
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
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(User.all).to be_empty
  end

  it 'e não cria uma conta com campos inválidos' do
    create(:user, email: 'email@email.com')

    visit new_user_registration_path
    fill_in 'CPF', with: '123456789'
    fill_in 'E-mail', with: 'email@email.com'
    fill_in 'Senha', with: '12345'
    fill_in 'Confirme sua senha', with: ''
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'CPF inválido'
    expect(page).to have_content 'E-mail já está em uso'
    expect(page).to have_content 'Senha é muito curta (mínimo: 6 caracteres)'
    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
    expect(User.count).to eq 1
  end
end
