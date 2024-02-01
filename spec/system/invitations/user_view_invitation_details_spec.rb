require 'rails_helper'

describe 'Usuário vê detalhes de um convite' do
  it 'a partir da página inicial' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    second_project = create :project, user: owner, title: 'Projeto Master', category: 'Aplicação WEB',
                                      description: 'Um projeto sobre masterizar tudo que é possível'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(id: 1, name: 'Designer')])
    create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                        message: 'Gostaria de te convidar', expiration_days: 8
    invitation = create :invitation, profile_id: profile.id, project: second_project, profile_email: user.email,
                                     message: 'Por favor aceite', expiration_days: 5

    login_as user
    visit root_path
    click_on 'Convites'
    click_on 'Projeto Master'

    expect(page).to have_content 'Projeto Master: Um projeto sobre masterizar tudo que é possível'
    expect(page).to have_content 'Mensagem: Por favor aceite'
    expect(page).to have_content 'Categoria: Aplicação WEB'
    expect(page).to have_content "Validade: #{I18n.l 5.days.from_now.to_date}"
    expect(page).to have_current_path invitation_path invitation
  end

  it 'e ja aceitou o convite' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    create :project, user: owner, title: 'Projeto'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(id: 1, name: 'Designer')])
    invitation = create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                                     message: 'Gostaria de te convidar', expiration_days: 8, status: :accepted

    login_as user
    visit invitation_path invitation

    expect(page).to have_content 'Convite aceito'
    expect(page).not_to have_button 'Aceitar'
    expect(page).not_to have_button 'Recusar'
  end

  it 'e ja recusou o convite' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    create :project, user: owner, title: 'Projeto'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(id: 1, name: 'Designer')])
    invitation = create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                                     message: 'Gostaria de te convidar', expiration_days: 8, status: :declined

    login_as user
    visit invitation_path invitation

    expect(page).to have_content 'Convite recusado'
    expect(page).not_to have_button 'Aceitar'
    expect(page).not_to have_button 'Recusar'
  end

  it 'e convite ja expirou' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    create :project, user: owner, title: 'Projeto'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(id: 1, name: 'Designer')])
    invitation = create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                                     message: 'Gostaria de te convidar', expiration_days: 8

    travel_to(9.days.from_now) do
      login_as user
      visit invitation_path invitation

      expect(page).to have_content 'Convite expirado'
      expect(page).not_to have_button 'Aceitar'
      expect(page).not_to have_button 'Recusar'
    end
  end
end
