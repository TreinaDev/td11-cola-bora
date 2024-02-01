require 'rails_helper'

describe 'Usuário acessa convite' do
  context 'e deve estar autenticado' do
    it 'para acessar o index' do
      get invitations_path

      expect(response).to redirect_to new_user_session_path
    end

    it 'para acessar o show' do
      user = create(:user, cpf: '000.000.001-91')
      invitation = create(:invitation, profile_email: user.email)

      get(invitation_path(invitation))

      expect(response).to redirect_to new_user_session_path
    end
  end
end
