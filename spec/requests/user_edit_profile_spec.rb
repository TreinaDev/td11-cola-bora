require 'rails_helper'

describe 'Usuário edita perfil' do
  it 'de outro usuário sem sucesso' do
    user = create(:user, email: 'user@email.com', cpf: '787.077.980-67')
    other_user = create(:user, email: 'other_user@email.com', cpf: '047.813.770-25')
    create(:profile, first_name: 'Pedro', user:)
    create(:profile, first_name: 'Leandro', user: other_user)

    login_as user
    patch profile_path other_user.profile, params: { profile: { first_name: 'Fabricio' } }

    expect(other_user.profile.reload.first_name).to eq 'Leandro'
    expect(response).to redirect_to root_path
  end
end
