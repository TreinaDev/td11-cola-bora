require 'rails_helper'

describe 'Usuário tenta atualizar status do convite' do
  it 'de aceito para cancelado' do
    invitation = create(:invitation, status: :accepted)

    login_as(invitation.project.user)
    patch cancel_invitation_path(invitation.id)

    expect(response).to redirect_to root_path
    expect(invitation.reload.status).to eq 'accepted'
  end

  it 'de vencido para cancelado' do
    invitation = create(:invitation, status: :expired)

    login_as(invitation.project.user)
    patch cancel_invitation_path(invitation.id)

    expect(response).to redirect_to root_path
    expect(invitation.reload.status).to eq 'expired'
  end

  it 'de pendente para cancelado' do
    invitation = create(:invitation, status: :pending)

    login_as(invitation.project.user)
    patch cancel_invitation_path(invitation.id)

    expect(invitation.reload.status).to eq 'cancelled'
    expect(response).to redirect_to project_portfoliorrr_profile_path(invitation.project, invitation.profile_id)
  end

  it 'para cancelado, mas não é o lider do projeto' do
    user = create(:user)
    other_user = create(:user, cpf: '11859924050')

    project = create(:project, user:)
    create(:project, user: other_user)

    invitation = create(:invitation, status: :pending, project:)

    login_as(other_user)
    patch cancel_invitation_path(invitation.id)

    expect(invitation.reload.status).to eq 'pending'
    expect(response).to redirect_to root_path
  end

  it 'mas não está autenticado' do
    invitation = create(:invitation, status: :pending)

    patch cancel_invitation_path(invitation.id)

    expect(invitation.reload.status).to eq 'pending'
    expect(response).to redirect_to new_user_session_path
  end
end
