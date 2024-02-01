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

  it 'aceitando um convite que foi cancelado' do
    project = create(:project)
    invited = create(:user, cpf: '000.000.001-91')
    invitation = create(:invitation, profile_email: invited.email, project:, status: :cancelled)

    login_as(invited)
    patch(accept_invitation_path(invitation))

    expect(invitation.reload.status).to eq 'cancelled'
    expect(flash[:alert]).to eq 'Não foi possível aceitar o convite'
    expect(response).to redirect_to root_path
  end

  it 'recusando um convite que foi cancelado' do
    project = create(:project)
    invited = create(:user, cpf: '000.000.001-91')
    invitation = create(:invitation, profile_email: invited.email, project:, status: :cancelled)

    login_as(invited)
    patch(decline_invitation_path(invitation))

    expect(invitation.reload.status).to eq 'cancelled'
    expect(flash[:alert]).to eq 'Não foi possível recusar o convite'
    expect(response).to redirect_to root_path
  end
end
