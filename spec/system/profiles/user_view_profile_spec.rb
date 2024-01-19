require 'rails_helper'

describe 'Usuário visualiza perfil' do
  it 'sem informações' do
    user = create(:user)
    user.profile.update(first_name: '', last_name: '',
                        work_experience: '', education: '')

    login_as user, scope: :user
    visit root_path
    click_on 'Meu perfil'

    expect(page).not_to have_content 'Nome: '
    expect(page).not_to have_content 'Experiência profissional: '
    expect(page).not_to have_content 'Informação acadêmica: '
    expect(page).to have_content 'Seu perfil ainda não tem informações'
    expect(page).to have_content 'Clique no botão abaixo para preencher'
    expect(page).to have_link 'Completar perfil'
  end
end
