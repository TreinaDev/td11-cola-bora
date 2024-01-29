require 'rails_helper'

describe 'Usuário visualiza perfil' do
  it 'sem informações' do
    user = create(:user)
    user.profile.update(first_name: '', last_name: '',
                        work_experience: '', education: '')

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Perfil'

    expect(page).not_to have_content 'Nome: '
    expect(page).not_to have_content 'Experiência profissional: '
    expect(page).not_to have_content 'Informação acadêmica: '
    expect(page).to have_content 'Seu perfil ainda não tem informações'
    expect(page).to have_content 'Clique no botão abaixo para preencher'
    expect(page).to have_link 'Completar perfil'
  end

  it 'com informações' do
    user = create(:user)
    user.profile.update(first_name: 'Pedro', last_name: 'Silva',
                        work_experience: 'Programador', education: 'Ciências da Computação')

    login_as user, scope: :user
    visit profile_path user.profile

    expect(page).to have_content 'Nome: Pedro Silva'
    expect(page).to have_content 'Experiência profissional: Programador'
    expect(page).to have_content 'Informação acadêmica: Ciências da Computação'
  end
end
