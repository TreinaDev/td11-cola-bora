require 'rails_helper'

describe 'Líder vê solicitações de um projeto' do
  it 'que estão pendentes' do
    leader = create :user
    project = create :project, user: leader
    pending_proposal = create :proposal, project:, status: :pending,
                                         email: 'proposer1@email.com',
                                         message: 'Solicitação pendente!'
    create :proposal, project:, status: :accepted,
                      email: 'proposer2@email.com',
                      message: 'Solicitação aceita!'
    create :proposal, project:, status: :declined,
                      email: 'proposer3@email.com',
                      message: 'Solicitação recusada!'
    create :proposal, project:, status: :cancelled,
                      email: 'proposer4@email.com',
                      message: 'Solicitação cancelada!'

    login_as leader, scope: :user
    visit project_path project
    within '#project-navbar' do
      click_on 'Solicitações'
    end

    expect(page).to have_content 'Pendente'
    expect(page).to have_content 'proposer1@email.com'
    expect(page).to have_content 'Solicitação pendente!'
    expect(page).to have_content "#{time_ago_in_words pending_proposal.created_at} atrás"
    expect(page).not_to have_content 'proposer2@email.com'
    expect(page).not_to have_content 'Solicitação aceita!'
    expect(page).not_to have_content 'proposer3@email.com'
    expect(page).not_to have_content 'Solicitação recusada!'
    expect(page).not_to have_content 'proposer4@email.com'
    expect(page).not_to have_content 'Solicitação cancelada!'
  end

  xit 'e filtra por todas' do
  end
end
