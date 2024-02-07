require 'rails_helper'

describe 'Líder vê solicitações de um projeto' do
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
    visit project_proposals_path(project)

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
    visit project_path project
    within '#project-navbar' do
      click_on 'Solicitações'
    end
    click_on 'Pendentes'

    expect(page).to have_content 'Pendente'
    expect(page).to have_content 'pending@email.com'
    expect(page).to have_content 'Solicitação pendente!'
    expect(page).to have_content "#{time_ago_in_words pending_proposal.created_at} atrás"
    expect(page).not_to have_content 'accepted@email.com'
    expect(page).not_to have_content 'Solicitação aceita!'
    expect(page).not_to have_content 'declined@email.com'
    expect(page).not_to have_content 'Solicitação recusada!'
    expect(page).not_to have_content 'cancelled@email.com'
    expect(page).not_to have_content 'Solicitação cancelada!'
  end
end
