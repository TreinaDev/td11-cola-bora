require 'rails_helper'

describe 'Usuário tenta atualizar status do convite' do
  context 'como líder' do
    it 'de aceito para cancelado' do
      leader = create(:user)
      project = create(:project, user: leader)
      invited = create(:user, cpf: '942.275.100-40')
      invitation = create(:invitation, status: :accepted, profile_email: invited.email, project:)

      login_as(leader)
      patch cancel_invitation_path(invitation.id)

      expect(response).to redirect_to root_path
      expect(invitation.reload.status).to eq 'accepted'
    end

    it 'de vencido para cancelado' do
      leader = create(:user)
      project = create(:project, user: leader)
      invited = create(:user, cpf: '942.275.100-40')
      invitation = create(:invitation, status: :expired, profile_email: invited.email, project:)

      login_as(leader)
      patch cancel_invitation_path(invitation.id)

      expect(response).to redirect_to root_path
      expect(invitation.reload.status).to eq 'expired'
    end
    it 'de pendente para cancelado' do
      leader = create(:user)
      project = create(:project, user: leader)
      invited = create(:user, cpf: '942.275.100-40')
      invitation = create(:invitation, status: :pending, profile_email: invited.email, project:)

      login_as(leader)
      patch cancel_invitation_path(invitation.id)

      expect(invitation.reload.status).to eq 'cancelled'
      expect(response).to redirect_to project_portfoliorrr_profile_path(invitation.project, invitation.profile_id)
    end
  end
  it 'para cancelado, mas não é o lider do projeto' do
    leader = create(:user)
    project = create(:project, user: leader)
    leader2 = create(:user, cpf: '11859924050')
    create(:project, user: leader2)
    invited = create(:user, cpf: '942.275.100-40')
    invitation = create(:invitation, status: :pending, profile_email: invited.email, project:)

    login_as(leader2)
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
