require 'rails_helper'

describe 'Usuário vê solicitações de um projeto' do
  context 'do qual é líder' do
    it 'com sucesso' do
      leader = create :user
      project = create :project, user: leader
      pending_proposal = create :proposal, project:, status: :pending,
                                           email: 'pending@email.com',
                                           message: 'Solicitação pendente'
      accepted_proposal = create :proposal, project:, status: :accepted,
                                            email: 'accepted@email.com',
                                            message: 'Solicitação aceita'
      refused_proposal = create :proposal, project:, status: :declined,
                                           email: 'declined@email.com',
                                           message: 'Solicitação recusada'
      cancelled_proposal = create :proposal, project:, status: :cancelled,
                                             email: 'cancelled@email.com',
                                             message: 'Solicitação cancelada'

      login_as leader, scope: :user
      visit project_path project
      within '#project-navbar' do
        click_on 'Solicitações'
      end

      within '#proposals-list' do
        expect(page).to have_content 'Pendente'
        expect(page).to have_content 'pending@email.com'
        expect(page).to have_content 'Solicitação pendente'
        expect(page).to have_content "#{time_ago_in_words pending_proposal.created_at} atrás"
        expect(page).to have_content 'Aceita'
        expect(page).to have_content 'accepted@email.com'
        expect(page).to have_content 'Solicitação aceita'
        expect(page).to have_content "#{time_ago_in_words accepted_proposal.created_at} atrás"
        expect(page).to have_content 'Recusada'
        expect(page).to have_content 'declined@email.com'
        expect(page).to have_content 'Solicitação recusada'
        expect(page).to have_content "#{time_ago_in_words refused_proposal.created_at} atrás"
        expect(page).to have_content 'Cancelada'
        expect(page).to have_content 'cancelled@email.com'
        expect(page).to have_content 'Solicitação cancelada'
        expect(page).to have_content "#{time_ago_in_words cancelled_proposal.created_at} atrás"
      end
    end

    it 'que estão pendentes' do
      leader = create :user
      project = create :project, user: leader
      pending_proposal = create :proposal, project:, status: :pending,
                                           email: 'pending@email.com',
                                           message: 'Solicitação pendente!'
      create :proposal, project:, status: :accepted,
                        email: 'accepted@email.com',
                        message: 'Solicitação aceita!'
      create :proposal, project:, status: :declined,
                        email: 'declined@email.com',
                        message: 'Solicitação recusada!'
      create :proposal, project:, status: :cancelled,
                        email: 'cancelled@email.com',
                        message: 'Solicitação cancelada!'

      login_as leader, scope: :user
      visit project_proposals_path(project)
      click_on 'Pendentes'

      within '#proposals-list' do
        expect(page).to have_content 'Pendente'
        expect(page).to have_content 'pending@email.com'
        expect(page).to have_content 'Solicitação pendente!'
        expect(page).to have_content "#{time_ago_in_words pending_proposal.created_at} atrás"
        expect(page).to have_link 'Visualizar'
        expect(page).not_to have_content 'accepted@email.com'
        expect(page).not_to have_content 'Solicitação aceita!'
        expect(page).not_to have_content 'declined@email.com'
        expect(page).not_to have_content 'Solicitação recusada!'
        expect(page).not_to have_content 'cancelled@email.com'
        expect(page).not_to have_content 'Solicitação cancelada!'
      end
    end

    it 'que foram aceitas' do
      leader = create :user
      project = create :project, user: leader
      accepted_proposal = create :proposal, project:, status: :accepted,
                                            email: 'accepted@email.com',
                                            message: 'Solicitação aceita'
      create :proposal, project:, status: :pending,
                        email: 'pending@email.com',
                        message: 'Solicitação pendente'
      create :proposal, project:, status: :declined,
                        email: 'declined@email.com',
                        message: 'Solicitação recusada'
      create :proposal, project:, status: :cancelled,
                        email: 'cancelled@email.com',
                        message: 'Solicitação cancelada'

      login_as leader, scope: :user
      visit project_proposals_path(project)
      click_on 'Aceitas'

      within '#proposals-list' do
        expect(page).to have_content 'Aceita'
        expect(page).to have_content 'accepted@email.com'
        expect(page).to have_content 'Solicitação aceita'
        expect(page).to have_content "#{time_ago_in_words accepted_proposal.created_at} atrás"
        expect(page).not_to have_link 'Visualizar'
        expect(page).not_to have_content 'Pendente'
        expect(page).not_to have_content 'pending@email.com'
        expect(page).not_to have_content 'Solicitação pendente'
        expect(page).not_to have_content 'Recusada'
        expect(page).not_to have_content 'declined@email.com'
        expect(page).not_to have_content 'Solicitação recusada'
        expect(page).not_to have_content 'Cancelada'
        expect(page).not_to have_content 'cancelled@email.com'
        expect(page).not_to have_content 'Solicitação cancelada'
      end
    end

    it 'que foram recusadas' do
      leader = create :user
      project = create :project, user: leader
      declined_proposal = create :proposal, project:, status: :declined,
                                            email: 'declined@email.com',
                                            message: 'Solicitação recusada'
      create :proposal, project:, status: :accepted,
                        email: 'accepted@email.com',
                        message: 'Solicitação aceita'
      create :proposal, project:, status: :pending,
                        email: 'pending@email.com',
                        message: 'Solicitação pendente'
      create :proposal, project:, status: :cancelled,
                        email: 'cancelled@email.com',
                        message: 'Solicitação cancelada'

      login_as leader, scope: :user
      visit project_proposals_path(project)
      click_on 'Recusadas'

      within '#proposals-list' do
        expect(page).to have_content 'Recusada'
        expect(page).to have_content 'declined@email.com'
        expect(page).to have_content 'Solicitação recusada'
        expect(page).to have_content "#{time_ago_in_words declined_proposal.created_at} atrás"
        expect(page).not_to have_link 'Visualizar'
        expect(page).not_to have_content 'Aceita'
        expect(page).not_to have_content 'accepted@email.com'
        expect(page).not_to have_content 'Solicitação aceita'
        expect(page).not_to have_content 'Pendente'
        expect(page).not_to have_content 'pending@email.com'
        expect(page).not_to have_content 'Solicitação pendente'
        expect(page).not_to have_content 'Cancelada'
        expect(page).not_to have_content 'cancelled@email.com'
        expect(page).not_to have_content 'Solicitação cancelada'
      end
    end

    it 'que foram canceladas' do
      leader = create :user
      project = create :project, user: leader
      cancelled_proposal = create :proposal, project:, status: :cancelled,
                                             email: 'cancelled@email.com',
                                             message: 'Solicitação cancelada'
      create :proposal, project:, status: :declined,
                        email: 'declined@email.com',
                        message: 'Solicitação recusada'
      create :proposal, project:, status: :accepted,
                        email: 'accepted@email.com',
                        message: 'Solicitação aceita'
      create :proposal, project:, status: :pending,
                        email: 'pending@email.com',
                        message: 'Solicitação pendente'

      login_as leader, scope: :user
      visit project_proposals_path(project)
      click_on 'Canceladas'

      within '#proposals-list' do
        expect(page).to have_content 'Cancelada'
        expect(page).to have_content 'cancelled@email.com'
        expect(page).to have_content 'Solicitação cancelada'
        expect(page).to have_content "#{time_ago_in_words cancelled_proposal.created_at} atrás"
        expect(page).not_to have_link 'Visualizar'
        expect(page).not_to have_content 'Recusada'
        expect(page).not_to have_content 'declined@email.com'
        expect(page).not_to have_content 'Solicitação recusada'
        expect(page).not_to have_content 'Aceita'
        expect(page).not_to have_content 'accepted@email.com'
        expect(page).not_to have_content 'Solicitação aceita'
        expect(page).not_to have_content 'Pendente'
        expect(page).not_to have_content 'pending@email.com'
        expect(page).not_to have_content 'Solicitação pendente'
      end
    end

    it 'que não tem nenhuma solicitação' do
      leader = create :user
      project = create :project, user: leader

      login_as leader, scope: :user
      visit project_proposals_path project

      expect(page).to have_content 'Nenhuma solicitação encontrada'
    end
  end

  it 'do qual é administrador sem sucesso' do
    project = create :project
    admin = create :user, cpf: '437.580.040-20'
    create :user_role, project:, user: admin, role: :admin

    login_as admin, scope: :user
    visit project_path project

    within '#project-navbar' do
      expect(page).not_to have_link 'Solicitações'
    end
  end

  it 'do qual é contribuidor sem sucesso' do
    project = create :project
    contributor = create :user, cpf: '437.580.040-20'
    create :user_role, project:, user: contributor, role: :contributor

    login_as contributor, scope: :user
    visit project_path project

    within '#project-navbar' do
      expect(page).not_to have_link 'Solicitações'
    end
  end
end
