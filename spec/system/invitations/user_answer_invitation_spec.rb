require 'rails_helper'

describe 'Usuário reponde convite' do
  it 'como aceito' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    second_project = create :project, user: owner, title: 'Projeto Master', category: 'Aplicação WEB',
                                      description: 'Um projeto sobre masterizar tudo que é possível'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(name: 'Designer')])
    invitation = create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                                     message: 'Gostaria de te convidar', expiration_days: 8
    second_invitation = create :invitation, profile_id: profile.id, project: second_project, profile_email: user.email,
                                            message: 'Por favor aceite', expiration_days: 5

    login_as user
    visit root_path
    click_on 'Convites'
    click_on 'Projeto Master'
    click_on 'Aceitar'

    expect(project.member?(user)).to eq false
    expect(second_project.member?(user)).to eq true
    expect(second_invitation.reload.status).to eq 'accepted'
    expect(invitation.reload.status).to eq 'pending'
    expect(page).to have_content 'Parabéns, você agora faz parte deste projeto!'
    expect(page).to have_content 'Projeto Master'
    expect(current_path).to eq project_path second_project
  end

  it 'como recusado' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    second_project = create :project, user: owner, title: 'Projeto Master', category: 'Aplicação WEB',
                                      description: 'Um projeto sobre masterizar tudo que é possível'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(name: 'Designer')])
    invitation = create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                                     message: 'Gostaria de te convidar', expiration_days: 8
    second_invitation = create :invitation, profile_id: profile.id, project: second_project, profile_email: user.email,
                                            message: 'Por favor aceite', expiration_days: 5

    login_as user
    visit root_path
    click_on 'Convites'
    click_on 'Projeto Master'
    click_on 'Recusar'

    expect(second_project.member?(user)).to eq false
    expect(second_invitation.reload.status).to eq 'declined'
    expect(invitation.reload.status).to eq 'pending'
    expect(page).to have_content 'Você recusou o convite'
    expect(current_path).to eq invitations_path
    expect(page).not_to have_content 'Projeto Master'
    expect(page).not_to have_content 'Por favor aceite'
    expect(page).not_to have_content 'Aplicação WEB'
    expect(page).not_to have_content "Validade: #{I18n.l 5.days.from_now.to_date}"
    expect(page).to have_content 'Projeto Top'
    expect(page).to have_content 'Gostaria de te convidar'
    expect(page).to have_content 'Categoria: Video'
    expect(page).to have_content "Validade: #{I18n.l 8.days.from_now.to_date}"
  end
end
