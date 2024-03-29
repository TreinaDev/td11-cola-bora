require 'rails_helper'

describe 'Usuário edita perfil' do
  it 'de outro usuário sem sucesso' do
    user = create(:user, email: 'user@email.com', cpf: '787.077.980-67')
    user.profile.update(first_name: 'Pedro')
    other_user = create(:user, email: 'other_user@email.com', cpf: '047.813.770-25')
    other_user.profile.update(first_name: 'Leandro')

    login_as user
    patch profile_path other_user.profile, params: { profile: { first_name: 'Fabricio' } }

    expect(other_user.profile.reload.first_name).to eq 'Leandro'
    expect(response).to redirect_to root_path
  end

  it 'com sucesso' do
    user = create(:user)
    user.profile.update(first_name: 'Pedro')

    login_as user
    patch profile_path user.profile, params: { profile: { first_name: 'Jonas' } }

    expect(user.profile.reload.first_name).to eq 'Jonas'
    expect(response).to redirect_to profile_path user.profile
  end

  it 'e não está autenticado' do
    user = create(:user)
    user.profile.update(first_name: 'Pedro')

    patch profile_path user.profile, params: { profile: { first_name: 'Jonas' } }

    expect(user.profile.reload.first_name).not_to eq 'Jonas'
    expect(response).to redirect_to new_user_session_path
  end
end
