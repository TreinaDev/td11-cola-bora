require 'rails_helper'

describe 'Usuário vê convites' do
  it 'a partir da página inicial' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    second_project = create :project, user: owner, title: 'Projeto Master', category: 'Aplicação WEB'
    create :project, user: owner, title: 'Projeto'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(id: 1, name: 'Designer')])
    create :invitation, profile_id: profile.id, project:, profile_email: user.email,
                        message: 'Gostaria de te convidar', expiration_days: 8, status: :pending
    create :invitation, profile_id: profile.id, project: second_project, profile_email: user.email,
                        message: 'Por favor aceite', expiration_days: 5, status: :pending

    login_as user
    visit root_path
    click_on 'Convites'

    expect(current_path).to eq invitations_path
    expect(page).to have_content 'Projeto Top'
    expect(page).to have_content 'Gostaria de te convidar'
    expect(page).to have_content 'Categoria: Video'
    expect(page).to have_content "Validade: #{I18n.l 8.days.from_now.to_date}"
    expect(page).to have_content 'Projeto Master'
    expect(page).to have_content 'Por favor aceite'
    expect(page).to have_content 'Aplicação WEB'
    expect(page).to have_content "Validade: #{I18n.l 5.days.from_now.to_date}"
  end

  it 'e não tem nenhum convite' do
    owner = create :user
    project = create :project, user: owner, title: 'Projeto Top', category: 'Video'
    user = create :user, cpf: '000.000.001-91'
    profile = PortfoliorrrProfile.new(id: 92, name: 'Pedro', job_categories: [JobCategory.new(id: 1, name: 'Designer')])
    create :invitation, profile_id: profile.id, project:,
                        message: 'Gostaria de te convidar', expiration_days: 8

    login_as(user)
    visit root_path
    click_on 'Convites'

    expect(page).to have_content 'Não há convites registrados'
    expect(page).not_to have_content 'Projeto Top'
    expect(page).not_to have_content 'Categoria: Video'
    expect(page).not_to have_content "Validade: #{I18n.l 8.days.from_now.to_date}"
  end
end
