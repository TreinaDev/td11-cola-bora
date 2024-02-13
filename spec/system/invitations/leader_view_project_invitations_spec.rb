require 'rails_helper'

describe 'Líder vê convites de um projeto' do
  it 'a partir da página do projeto' do
    leader = create :user
    project = create :project, user: leader
    pending_invitation    = create :invitation, expiration_days: 5,  profile_id: 55,   project:,
                                                profile_email: 'pending@email.com',    status: :pending
    accepted_invitation   = create :invitation, expiration_days: '', profile_id: 66,   project:,
                                                profile_email: 'accepted@email.com',   status: :accepted
    declined_invitation   = create :invitation, expiration_days: '', profile_id: 77,   project:,
                                                profile_email: 'declined@email.com',   status: :declined
    cancelled_invitation  = create :invitation, expiration_days: '', profile_id: 88,   project:,
                                                profile_email: 'cancelled@email.com',  status: :cancelled
    processing_invitation = create :invitation, expiration_days: '', profile_id: 99,   project:,
                                                profile_email: 'processing@email.com', status: :processing
    expired_invitation    = create :invitation, expiration_days: '', profile_id: 99,   project:,
                                                profile_email: 'expired@email.com',    status: :expired

    login_as leader, scope: :user
    visit project_path project
    within '#project-navbar' do
      click_on 'Convites'
    end

    within '#invitations-list' do
      expect(page).to have_content 'Convite pendente'
      expect(page).to have_content 'pending@email.com'
      expect(page).to have_content "Expira em #{pending_invitation.expiration_days - 1} dias"
      expect(page).to have_content "#{time_ago_in_words pending_invitation.updated_at} atrás"
      expect(page).to have_content 'Convite aceito'
      expect(page).to have_content 'accepted@email.com'
      expect(page).to have_content 'Sem prazo de validade'
      expect(page).to have_content "#{time_ago_in_words accepted_invitation.updated_at} atrás"
      expect(page).to have_content 'Convite recusado'
      expect(page).to have_content 'declined@email.com'
      expect(page).to have_content "#{time_ago_in_words declined_invitation.updated_at} atrás"
      expect(page).to have_content 'Convite cancelado'
      expect(page).to have_content 'cancelled@email.com'
      expect(page).to have_content "#{time_ago_in_words cancelled_invitation.updated_at} atrás"
      expect(page).to have_content 'Convite em processamento'
      expect(page).to have_content 'processing@email.com'
      expect(page).to have_content "#{time_ago_in_words processing_invitation.updated_at} atrás"
      expect(page).to have_content 'Convite expirado'
      expect(page).to have_content 'expired@email.com'
      expect(page).to have_content "#{time_ago_in_words expired_invitation.updated_at} atrás"
    end
  end
end
