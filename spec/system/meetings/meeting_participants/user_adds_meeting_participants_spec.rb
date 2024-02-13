require 'rails_helper'

describe 'Usuário adiciona participantes a reunião' do
  it 'com sucesso' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader
    author = create :user, cpf: '607.149.470-24', email: 'author@email.com'
    author_role = create :user_role, project:, user: author, role: :contributor
    future_participant1 = create :user, cpf: '850.265.590-69', email: 'participant1@email.com'
    create :user_role, project:, user: future_participant1, role: :admin
    future_participant2 = create :user, cpf: '359.739.000-53', email: 'participant2@email.com'
    create :user_role, project:, user: future_participant2, role: :contributor
    not_invited = create :user, cpf: '781.720.590-60', email: 'not_invited@email.com'
    create :user_role, project:, user: not_invited, role: :contributor
    meeting = create :meeting, project:, title: 'Reunião Semanal', user_role: author_role

    mail = double('mail', deliver: true)
    mailer_double = double('MeetingParticipantMailer', notify_meeting_participants: mail)

    allow(MeetingParticipantMailer).to receive(:with).and_return(mailer_double)
    allow(mailer_double).to receive(:notify_meeting_participants).and_return(mail)

    login_as author
    visit project_meeting_path project, meeting
    click_on 'Adicionar Participantes'
    check 'leader'
    check 'participant1'
    check 'participant2'
    click_on 'Adicionar'

    expect(page).to have_current_path project_meeting_path project, meeting
    expect(page).to have_content 'Lista de Participantes'
    expect(page).to have_content 'leader'
    expect(page).to have_content 'participant1'
    expect(page).to have_content 'participant2'
    expect(page).not_to have_content 'not_invited'
    expect(page).not_to have_link 'Adicionar Participantes'
    expect(page).to have_content 'Participantes adicionados com sucesso!'
    expect(mailer_double).to have_received(:notify_meeting_participants).exactly(3).times
    expect(mail).to have_received(:deliver).exactly(3).times
  end

  it 'e não vê usuários que não fazem parte do projeto' do
    leader = create :user, email: 'leader@email.com', cpf: '761.437.950-02'
    project = create :project, user: leader
    author = create :user, cpf: '607.149.470-24', email: 'author@email.com'
    author_role = create :user_role, project:, user: author, role: :contributor
    create :user, cpf: '781.720.590-60', email: 'non_member@email.com'
    meeting = create :meeting, project:, title: 'Reunião Semanal', user_role: author_role

    login_as author
    visit new_meeting_meeting_participant_path meeting

    expect(page).to have_unchecked_field 'leader'
    expect(page).to have_unchecked_field 'author'
    expect(page).not_to have_content 'non_member'
  end

  it 'e ninguém é adicionado' do
    leader = create :user, email: 'leader@email.com', cpf: '761.437.950-02'
    project = create :project, user: leader
    author = create :user, cpf: '607.149.470-24', email: 'author@email.com'
    author_role = create :user_role, project:, user: author, role: :contributor
    meeting = create :meeting, project:, title: 'Reunião Semanal', user_role: author_role

    login_as author
    visit new_meeting_meeting_participant_path meeting
    click_on 'Adicionar'

    expect(page).to have_content 'Selecione ao menos 2 participantes'
    expect(page).to have_current_path new_meeting_meeting_participant_path meeting
  end

  it 'e adiciona apenas uma pessoa' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader
    author = create :user, cpf: '607.149.470-24', email: 'author@email.com'
    author_role = create :user_role, project:, user: author, role: :contributor
    meeting = create :meeting, project:, title: 'Reunião Semanal', user_role: author_role

    login_as author
    visit new_meeting_meeting_participant_path meeting
    check 'leader'
    click_on 'Adicionar'

    expect(page).to have_content 'Selecione ao menos 2 participantes'
    expect(page).to have_current_path new_meeting_meeting_participant_path meeting
  end

  it 'somente autor adiciona participantes' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader
    author = create :user, cpf: '607.149.470-24', email: 'author@email.com'
    author_role = create :user_role, project:, user: author, role: :contributor
    future_participant1 = create :user, cpf: '850.265.590-69', email: 'participant1@email.com'
    create :user_role, project:, user: future_participant1, role: :admin
    meeting = create :meeting, project:, title: 'Reunião Semanal', user_role: author_role

    login_as future_participant1
    visit project_meeting_path project, meeting

    expect(page).not_to have_link 'Adicionar Participantes'
  end
end
