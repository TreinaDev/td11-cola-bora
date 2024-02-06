require 'rails_helper'

describe 'Usuário vê calendário do projeto' do
  it 'somente com reuniões' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu Projeto')

    travel_to Time.zone.now.beginning_of_month do
      first_daily = create(:meeting, project:, title: 'Daily 1', datetime: 9.days.from_now)
      second_daily = create(:meeting, project:, title: 'Daily 2', datetime: 10.days.from_now)
      third_daily = create(:meeting, project:, title: 'Daily 3', datetime: 11.days.from_now)
      task = create(:task, title: 'Tarefa 1', project:, due_date: 5.days.from_now)

      login_as user
      visit root_path
      click_on 'Projetos'
      click_on 'Meu Projeto'
      within '#project-navbar' do
        click_on 'Calendário'
      end
      select 'Reuniões', from: :filter
      click_on 'Filtrar'

      within "#day-#{first_daily.start_time.to_date}" do
        expect(page).to have_link 'Daily 1', href: project_meeting_path(project, first_daily)
      end
      within "#day-#{second_daily.start_time.to_date}" do
        expect(page).to have_link 'Daily 2', href: project_meeting_path(project, second_daily)
      end
      within "#day-#{third_daily.start_time.to_date}" do
        expect(page).to have_link 'Daily 3', href: project_meeting_path(project, third_daily)
      end
      within "#day-#{task.start_time.to_date}" do
        expect(page).not_to have_link 'Tarefa 1'
      end
    end
  end

  it 'somente com tarefas' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu Projeto')

    travel_to Time.zone.now.beginning_of_month do
      first_task = create(:task, title: 'Tarefa 1', project:, due_date: 5.days.from_now)
      second_task = create(:task, title: 'Tarefa 2', project:, due_date: 6.days.from_now)
      third_task = create(:task, title: 'Tarefa 3', project:, due_date: 7.days.from_now)
      daily = create(:meeting, project:, title: 'Daily 1', datetime: 9.days.from_now)

      login_as user
      visit project_calendars_path project
      select 'Tarefas', from: :filter
      click_on 'Filtrar'

      within "#day-#{first_task.start_time.to_date}" do
        expect(page).to have_link 'Tarefa 1', href: task_path(first_task)
      end
      within "#day-#{second_task.start_time.to_date}" do
        expect(page).to have_link 'Tarefa 2', href: task_path(second_task)
      end
      within "#day-#{third_task.start_time.to_date}" do
        expect(page).to have_link 'Tarefa 3', href: task_path(third_task)
      end
      within "#day-#{daily.start_time.to_date}" do
        expect(page).not_to have_link 'Daily 1'
      end
    end
  end

  it 'com reuniões e tarefas' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu Projeto')

    travel_to Time.zone.now.beginning_of_month do
      first_daily = create(:meeting, project:, title: 'Daily 1', datetime: 9.days.from_now)
      first_task = create(:task, title: 'Tarefa 1', project:, due_date: 9.days.from_now)

      second_daily = create(:meeting, project:, title: 'Daily 2', datetime: 10.days.from_now)
      second_task = create(:task, title: 'Tarefa 2', project:, due_date: 10.days.from_now)

      login_as user
      visit project_calendars_path project

      within "#day-#{first_daily.start_time.to_date}" do
        expect(page).to have_link 'Daily 1', href: project_meeting_path(project, first_daily)
        expect(page).to have_link 'Tarefa 1', href: task_path(first_task)
      end
      within "#day-#{second_daily.start_time.to_date}" do
        expect(page).to have_link 'Daily 2', href: project_meeting_path(project, second_daily)
        expect(page).to have_link 'Tarefa 2', href: task_path(second_task)
      end
    end
  end

  it 'e não vê eventos de outro projeto' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu Projeto')
    other_project = create(:project, user:, title: 'Outro Projeto')

    travel_to Time.zone.now.beginning_of_month do
      first_daily = create(:meeting, project:, title: 'Daily 1', datetime: 9.days.from_now)
      create(:task, title: 'Tarefa 1', project:, due_date: 9.days.from_now)

      second_daily = create(:meeting, project: other_project, title: 'Daily 2', datetime: 10.days.from_now)
      create(:task, title: 'Tarefa 2', project: other_project, due_date: 10.days.from_now)

      login_as user
      visit project_calendars_path project

      within "#day-#{first_daily.start_time.to_date}" do
        expect(page).to have_content 'Daily 1'
        expect(page).to have_content 'Tarefa 1'
      end
      within "#day-#{second_daily.start_time.to_date}" do
        expect(page).not_to have_content 'Daily 2'
        expect(page).not_to have_content 'Tarefa 2'
      end
    end
  end

  it 'somente com tarefas e volta para todos' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu Projeto')

    travel_to Time.zone.now.beginning_of_month do
      first_task = create(:task, title: 'Tarefa 1', project:, due_date: 5.days.from_now)
      create(:meeting, project:, title: 'Daily 1', datetime: 5.days.from_now)
      second_task = create(:task, title: 'Tarefa 2', project:, due_date: 6.days.from_now)
      create(:meeting, project:, title: 'Daily 2', datetime: 6.days.from_now)

      login_as user
      visit project_calendars_path project
      select 'Tarefas', from: :filter
      click_on 'Filtrar'
      select 'Todos', from: :filter
      click_on 'Filtrar'

      within "#day-#{first_task.start_time.to_date}" do
        expect(page).to have_content 'Tarefa 1'
        expect(page).to have_content 'Daily 1'
      end
      within "#day-#{second_task.start_time.to_date}" do
        expect(page).to have_content 'Tarefa 2'
        expect(page).to have_content 'Daily 2'
      end
    end
  end
end
