require 'rails_helper'

describe 'Usuário responde a um convite' do
  it 'e não é o convidado' do
    project = create(:project)
    invited = create(:user, cpf: '000.000.001-91')
    not_invited = create(:user, cpf: '942.275.100-40')
    invitation = create(:invitation, profile_email: invited.email, project:)

    login_as(not_invited)
    patch(accept_invitation_path(invitation))

    expect(invitation.reload.status).to eq 'pending'
    expect(response).to redirect_to root_path
  end
end
