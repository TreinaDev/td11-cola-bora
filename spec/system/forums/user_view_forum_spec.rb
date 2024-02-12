require 'rails_helper'

describe 'Usuário vê página de fórum de um projeto' do
  it 'a partir da tela inicial' do
    travel_to Time.zone.local(2024, 11, 24, 1, 4, 44)
    user = create(:user)
    project = create(:project, user:)

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Reuniões'

    expect(page).to have_content 'Fórum'
  end
end
