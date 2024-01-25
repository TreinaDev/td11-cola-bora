require 'rails_helper'

describe 'Lider revoga convite' do
  it 'e status muda para cancelado' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    json = File.read(Rails.root.join('spec/support/json/portfoliorrr_profile.json'))

    fake_response = double('faraday_response', status: 200, body: json)
    id = JSON.parse(fake_response.body)['id']
    url = "https://e07813cd-df3d-4023-920b-4037df5a0c31.mock.pstmn.io/profiles/#{id}"
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)

    create(:invitation, project:, profile_id: id)

    login_as user
    visit project_portfoliorrr_profile_path(project, id)
    click_on 'Cancelar convite'

    expect(page).to have_content 'Convite cancelado!'
    expect(current_path).to eq project_portfoliorrr_profile_path(project, id)
    expect(Invitation.last.cancelled?).to eq true
  end
end
