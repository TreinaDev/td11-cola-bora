require 'rails_helper'

describe 'Usuário reponde convite' do
  it 'positivamente' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    second_project = create :project, user: owner, title: 'Projeto Master', category: 'Aplicação WEB',
                                      description: 'Um projeto sobre masterizar tudo que é possível'
    create :project, user: owner, title: 'Projeto'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(name: 'Designer')])
    create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                        message: 'Gostaria de te convidar', expiration_days: 8
    invitation = create :invitation, profile_id: profile.id, project: second_project, profile_email: user.email,
                                     message: 'Por favor aceite', expiration_days: 5

    login_as user
    visit root_path
    click_on 'Convites'
    click_on 'Projeto Master'
    click_on 'Aceitar'

    expect(second_project.member?(user)).to eq true
    expect(invitation.reload.status).to eq 'accepted'
    expect(page).to have_content 'Parabéns, você agora faz parte deste projeto!'
    expect(page).to have_content 'Projeto Master'
    expect(current_path).to eq project_path second_project
  end
end
