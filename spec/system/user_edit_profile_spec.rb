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
    expect(page).to have_button 'Atualizar Perfil'
  end

  it 'com sucesso' do
    user = create(:user)
    create(:profile, user:, first_name: '', last_name: '',
                     work_experience: '', education: '')

    login_as user, scope: :user
    visit edit_profile_path user.profile
    fill_in 'Nome', with: 'Pedro'
    fill_in 'Sobrenome', with: 'Silva'
    fill_in 'Experiência profissional', with: 'Programador, Designer'
    fill_in 'Informação acadêmica', with: 'Ciências da Computação'
    click_on 'Atualizar Perfil'

    expect(current_path).to eq profile_path(user.profile)
    expect(page).to have_content 'Perfil atualizado com sucesso!'
    expect(page).to have_content 'Nome: Pedro Silva'
    expect(page).to have_content 'Experiência profissional: Programador, Designer'
    expect(page).to have_content 'Informação acadêmica: Ciências da Computação'
  end

  context 'e cancela edição de perfil' do
    it 'pela primeira vez' do
      profile = create(:profile, first_name: '', last_name: '',
                                 work_experience: '', education: '')

      login_as profile.user, scope: :user
      visit edit_profile_path profile
      click_on 'Pular etapa'

      expect(current_path).to eq profile_path profile
    end
  end

  xit 'deixa campo vazio'
  xit 'não é o dono do perfil'
  xit 'não está autenticado'
  xit 'pela primeira vez'
end
