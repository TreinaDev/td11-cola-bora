require 'rails_helper'

describe 'Usuário vê detalhes de um convites' do
  it 'a partir da página inicial' do
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

    expect(current_path).to eq invitation_path invitation
    expect(page).to have_content 'Projeto Master: Um projeto sobre masterizar tudo que é possível'
    expect(page).to have_content 'Mensagem: Por favor aceite'
    expect(page).to have_content 'Categoria: Aplicação WEB'
    expect(page).to have_content "Validade: #{I18n.l 5.days.from_now.to_date}"
  end
end