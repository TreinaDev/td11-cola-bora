require 'rails_helper'

describe 'Líder vê convites de um projeto' do
  include InvitationHelper

  it 'a partir da página do projeto' do
    leader = create :user
    project = create :project, user: leader
    first_pending_invitation  = create :invitation, expiration_days: 5,  profile_id: 55,   project:,
                                                    profile_email: 'pending@email.com',    status: :pending
    second_pending_invitation = create :invitation, expiration_days: '', profile_id: 56,   project:,
                                                    profile_email: 'pending2@email.com',   status: :pending
    accepted_invitation       = create :invitation, expiration_days: 1, profile_id: 66,    project:,
                                                    profile_email: 'accepted@email.com',   status: :accepted
    declined_invitation       = create :invitation, expiration_days: 2, profile_id: 77,    project:,
                                                    profile_email: 'declined@email.com',   status: :declined
    cancelled_invitation      = create :invitation, expiration_days: 3, profile_id: 88,    project:,
                                                    profile_email: 'cancelled@email.com',  status: :cancelled
    processing_invitation     = create :invitation, expiration_days: 4, profile_id: 99,    project:,
                                                    profile_email: 'processing@email.com', status: :processing
    expired_invitation        = create :invitation, expiration_days: 8, profile_id: 99,    project:,
                                                    profile_email: 'expired@email.com',    status: :expired

    login_as leader, scope: :user
    visit project_path project
    within '#project-navbar' do
      click_on 'Convites'
    end
    click_on 'Todos'

    expect(page).to have_content 'Convite pendente'
    expect(page).to have_content 'pending@email.com'
    expect(page).to have_content invitation_expiration_date(first_pending_invitation)
    expect(page).to have_content "Atualizado há #{time_ago_in_words first_pending_invitation.updated_at} atrás"
    expect(page).to have_content 'pending2@email.com'
    expect(page).to have_content invitation_expiration_date(second_pending_invitation)
    expect(page).to have_content "Atualizado há #{time_ago_in_words second_pending_invitation.updated_at} atrás"
    expect(page).to have_content 'Convite aceito'
    expect(page).to have_content 'accepted@email.com'
    expect(page).not_to have_content invitation_expiration_date(accepted_invitation)
    expect(page).to have_content "Atualizado há #{time_ago_in_words accepted_invitation.updated_at} atrás"
    expect(page).to have_content 'Convite recusado'
    expect(page).to have_content 'declined@email.com'
    expect(page).not_to have_content invitation_expiration_date(declined_invitation)
    expect(page).to have_content "Atualizado há #{time_ago_in_words declined_invitation.updated_at} atrás"
    expect(page).to have_content 'Convite cancelado'
    expect(page).to have_content 'cancelled@email.com'
    expect(page).not_to have_content invitation_expiration_date(cancelled_invitation)
    expect(page).to have_content "Atualizado há #{time_ago_in_words cancelled_invitation.updated_at} atrás"
    expect(page).to have_content 'Convite em processamento'
    expect(page).to have_content 'processing@email.com'
    expect(page).not_to have_content invitation_expiration_date(processing_invitation)
    expect(page).to have_content "Atualizado há #{time_ago_in_words processing_invitation.updated_at} atrás"
    expect(page).to have_content 'Convite expirado'
    expect(page).to have_content 'expired@email.com'
    expect(page).not_to have_content invitation_expiration_date(expired_invitation)
    expect(page).to have_content "Atualizado há #{time_ago_in_words expired_invitation.updated_at} atrás"
    expect(page).not_to have_content 'Nenhum convite encontrado'
  end

  it 'e filtra por pendentes' do
    leader = create :user
    project = create :project, user: leader
    pending_invitation = create :invitation, expiration_days: 5, profile_id: 55, project:,
                                             profile_email: 'pending@email.com', status: :pending
    create :invitation, expiration_days: '', profile_id: 66,   project:,
                        profile_email: 'accepted@email.com',   status: :accepted
    create :invitation, expiration_days: '', profile_id: 77,   project:,
                        profile_email: 'declined@email.com',   status: :declined
    create :invitation, expiration_days: '', profile_id: 88,   project:,
                        profile_email: 'cancelled@email.com',  status: :cancelled
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'processing@email.com', status: :processing
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'expired@email.com',    status: :expired

    login_as leader, scope: :user
    visit project_invitations_path project
    click_on 'Pendentes'

    within '#invitations-list' do
      expect(page).to have_content 'Convite pendente'
      expect(page).to have_content 'pending@email.com'
      expect(page).to have_content invitation_expiration_date(pending_invitation)
      expect(page).to have_content "Atualizado há #{time_ago_in_words pending_invitation.updated_at} atrás"
      expect(page).not_to have_content 'Convite aceito'
      expect(page).not_to have_content 'accepted@email.com'
      expect(page).not_to have_content 'Sem prazo de validade'
      expect(page).not_to have_content 'Convite recusado'
      expect(page).not_to have_content 'declined@email.com'
      expect(page).not_to have_content 'Convite cancelado'
      expect(page).not_to have_content 'cancelled@email.com'
      expect(page).not_to have_content 'Convite em processamento'
      expect(page).not_to have_content 'processing@email.com'
      expect(page).not_to have_content 'Convite expirado'
      expect(page).not_to have_content 'expired@email.com'
      expect(page).not_to have_content 'Nenhum convite encontrado'
    end
  end

  it 'e filtra por aceitos' do
    leader = create :user
    project = create :project, user: leader
    accepted_invitation = create :invitation, expiration_days: '', profile_id: 66,   project:,
                                              profile_email: 'accepted@email.com',   status: :accepted
    create :invitation, expiration_days: 5, profile_id: 55, project:,
                        profile_email: 'pending@email.com', status: :pending
    create :invitation, expiration_days: '', profile_id: 77,   project:,
                        profile_email: 'declined@email.com',   status: :declined
    create :invitation, expiration_days: '', profile_id: 88,   project:,
                        profile_email: 'cancelled@email.com',  status: :cancelled
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'processing@email.com', status: :processing
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'expired@email.com',    status: :expired

    login_as leader, scope: :user
    visit project_invitations_path project
    click_on 'Aceitos'

    within '#invitations-list' do
      expect(page).to have_content 'Convite aceito'
      expect(page).to have_content 'accepted@email.com'
      expect(page).not_to have_content invitation_expiration_date(accepted_invitation)
      expect(page).to have_content "Atualizado há #{time_ago_in_words accepted_invitation.updated_at} atrás"
      expect(page).not_to have_content 'Convite pendente'
      expect(page).not_to have_content 'pending@email.com'
      expect(page).not_to have_content 'Expira em 4 dias'
      expect(page).not_to have_content 'Convite recusado'
      expect(page).not_to have_content 'declined@email.com'
      expect(page).not_to have_content 'Convite cancelado'
      expect(page).not_to have_content 'cancelled@email.com'
      expect(page).not_to have_content 'Convite em processamento'
      expect(page).not_to have_content 'processing@email.com'
      expect(page).not_to have_content 'Convite expirado'
      expect(page).not_to have_content 'expired@email.com'
      expect(page).not_to have_content 'Nenhum convite encontrado'
    end
  end

  it 'e filtra por recusados' do
    leader = create :user
    project = create :project, user: leader
    declined_invitation = create :invitation, expiration_days: '', profile_id: 77,   project:,
                                              profile_email: 'declined@email.com',   status: :declined
    create :invitation, expiration_days: 5, profile_id: 55, project:,
                        profile_email: 'pending@email.com', status: :pending
    create :invitation, expiration_days: '', profile_id: 66,   project:,
                        profile_email: 'accepted@email.com',   status: :accepted
    create :invitation, expiration_days: '', profile_id: 88,   project:,
                        profile_email: 'cancelled@email.com',  status: :cancelled
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'processing@email.com', status: :processing
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'expired@email.com',    status: :expired

    login_as leader, scope: :user
    visit project_invitations_path project
    click_on 'Recusados'

    within '#invitations-list' do
      expect(page).to have_content 'Convite recusado'
      expect(page).to have_content 'declined@email.com'
      expect(page).to have_content "Atualizado há #{time_ago_in_words declined_invitation.updated_at} atrás"
      expect(page).not_to have_content invitation_expiration_date(declined_invitation)
      expect(page).not_to have_content 'Convite pendente'
      expect(page).not_to have_content 'pending@email.com'
      expect(page).not_to have_content 'Expira em 4 dias'
      expect(page).not_to have_content 'Convite aceinot_to'
      expect(page).not_to have_content 'accepted@email.com'
      expect(page).not_to have_content 'Convite cancelado'
      expect(page).not_to have_content 'cancelled@email.com'
      expect(page).not_to have_content 'Convite em processamento'
      expect(page).not_to have_content 'processing@email.com'
      expect(page).not_to have_content 'Convite expirado'
      expect(page).not_to have_content 'expired@email.com'
      expect(page).not_to have_content 'Nenhum convite encontrado'
    end
  end

  it 'e filtra por cancelados' do
    leader = create :user
    project = create :project, user: leader
    cancelled_invitation = create :invitation, expiration_days: '', profile_id: 88,   project:,
                                               profile_email: 'cancelled@email.com',  status: :cancelled
    create :invitation, expiration_days: 5, profile_id: 55, project:,
                        profile_email: 'pending@email.com', status: :pending
    create :invitation, expiration_days: '', profile_id: 66,   project:,
                        profile_email: 'accepted@email.com',   status: :accepted
    create :invitation, expiration_days: '', profile_id: 77,   project:,
                        profile_email: 'declined@email.com',   status: :declined
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'processing@email.com', status: :processing
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'expired@email.com',    status: :expired

    login_as leader, scope: :user
    visit project_invitations_path project
    click_on 'Cancelados'

    within '#invitations-list' do
      expect(page).to have_content 'Convite cancelado'
      expect(page).to have_content 'cancelled@email.com'
      expect(page).to have_content "Atualizado há #{time_ago_in_words cancelled_invitation.updated_at} atrás"
      expect(page).not_to have_content invitation_expiration_date(cancelled_invitation)
      expect(page).not_to have_content 'Convite pendente'
      expect(page).not_to have_content 'pending@email.com'
      expect(page).not_to have_content 'Expira em 4 dias'
      expect(page).not_to have_content 'Convite aceinot_to'
      expect(page).not_to have_content 'accepted@email.com'
      expect(page).not_to have_content 'Convite recusado'
      expect(page).not_to have_content 'declined@email.com'
      expect(page).not_to have_content 'Convite em processamento'
      expect(page).not_to have_content 'processing@email.com'
      expect(page).not_to have_content 'Convite expirado'
      expect(page).not_to have_content 'expired@email.com'
      expect(page).not_to have_content 'Nenhum convite encontrado'
    end
  end

  it 'e não encotnra nenhum convite' do
    leader = create :user
    project = create :project, user: leader
    expired_invitation = create :invitation, expiration_days: '', profile_id: 99, project:,
                                             profile_email: 'expired@email.com', status: :expired
    create :invitation, expiration_days: 5, profile_id: 55,    project:,
                        profile_email: 'pending@email.com',    status: :pending
    create :invitation, expiration_days: '', profile_id: 66,   project:,
                        profile_email: 'accepted@email.com',   status: :accepted
    create :invitation, expiration_days: '', profile_id: 77,   project:,
                        profile_email: 'declined@email.com',   status: :declined
    create :invitation, expiration_days: '', profile_id: 88,   project:,
                        profile_email: 'cancelled@email.com',  status: :cancelled
    create :invitation, expiration_days: '', profile_id: 99,   project:,
                        profile_email: 'processing@email.com', status: :processing

    login_as leader, scope: :user
    visit project_invitations_path project
    click_on 'Expirados'

    within '#invitations-list' do
      expect(page).to have_content 'Convite expirado'
      expect(page).to have_content 'expired@email.com'
      expect(page).to have_content "Atualizado há #{time_ago_in_words expired_invitation.updated_at} atrás"
      expect(page).not_to have_content invitation_expiration_date(expired_invitation)
      expect(page).not_to have_content 'Convite pendente'
      expect(page).not_to have_content 'pending@email.com'
      expect(page).not_to have_content 'Expira em 4 dias'
      expect(page).not_to have_content 'Convite aceinot_to'
      expect(page).not_to have_content 'accepted@email.com'
      expect(page).not_to have_content 'Convite recusado'
      expect(page).not_to have_content 'declined@email.com'
      expect(page).not_to have_content 'Convite cancelado'
      expect(page).not_to have_content 'cancelled@email.com'
      expect(page).not_to have_content 'Convite em processamento'
      expect(page).not_to have_content 'processing@email.com'
      expect(page).not_to have_content 'Nenhum convite encontrado'
    end
  end

  it 'e não encontra nenhum convite' do
    leader = create :user
    project = create :project, user: leader

    login_as leader, scope: :user
    visit project_invitations_path project

    within '#invitations-list' do
      expect(page).to have_content 'Nenhum convite encontrado'
    end
  end
  it 'do qual é administrador sem sucesso' do
    project = create :project
    admin = create :user, cpf: '437.580.040-20'
    create :user_role, project:, user: admin, role: :admin

    login_as admin, scope: :user
    visit project_path project

    within '#project-navbar' do
      expect(page).not_to have_link 'Convites'
    end
  end

  it 'do qual é contribuidor sem sucesso' do
    project = create :project
    contributor = create :user, cpf: '437.580.040-20'
    create :user_role, project:, user: contributor, role: :contributor

    login_as contributor, scope: :user
    visit project_path project

    within '#project-navbar' do
      expect(page).not_to have_link 'Convites'
    end
  end
end
