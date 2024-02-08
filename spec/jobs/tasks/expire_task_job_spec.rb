require 'rails_helper'

RSpec.describe ExpireTaskJob, type: :job do
  describe '#perform' do
    context 'muda para expirado quando excede prazo' do
      it 'e não está iniciado' do
        project = create :project
        contributor = create :user, cpf: '979.612.040-24'
        user_role = create :user_role, project:, user: contributor, role: :contributor
        task = create :task, due_date: 5.days.from_now, user_role:, project:, status: :uninitialized

        travel_to 5.days.from_now do
          ExpireTaskJob.perform_now task

          expect(task.reload.status).to eq 'expired'
        end
      end

      it 'e está em andamento' do
        project = create :project
        contributor = create :user, cpf: '979.612.040-24'
        user_role = create :user_role, project:, user: contributor, role: :contributor
        task = create :task, due_date: 5.days.from_now, user_role:, project:, status: :in_progress

        travel_to 5.days.from_now do
          ExpireTaskJob.perform_now task

          expect(task.reload.status).to eq 'expired'
        end
      end

      it 'e a tarefa foi criada com prazo e depois foi alterada para prazo maior' do
        project = create :project
        contributor = create :user, cpf: '979.612.040-24'
        user_role = create :user_role, project:, user: contributor, role: :contributor
        task = create :task, due_date: 1.day.from_now, user_role:, project:, status: :uninitialized

        task.update(due_date: 2.days.from_now.to_date)

        travel_to 1.day.from_now do
          ExpireTaskJob.perform_now task
          expect(task.reload.expired?).to eq false
        end

        travel_to 2.days.from_now do
          ExpireTaskJob.perform_now task
          expect(task.reload.expired?).to eq true
        end
      end

      it 'e a tarefa foi criada com prazo e depois foi alterada para prazo menor' do
        project = create :project
        contributor = create :user, cpf: '979.612.040-24'
        user_role = create :user_role, project:, user: contributor, role: :contributor
        task = create :task, due_date: 2.days.from_now, user_role:, project:, status: :uninitialized

        task.update(due_date: 1.day.from_now.to_date)

        travel_to 1.day.from_now do
          ExpireTaskJob.perform_now task
          expect(task.reload.expired?).to eq true
        end
      end
    end

    context 'não muda para expirado' do
      it 'quando está cancelado' do
        project = create :project
        contributor = create :user, cpf: '979.612.040-24'
        user_role = create :user_role, project:, user: contributor, role: :contributor
        task = create :task, due_date: 5.days.from_now, user_role:, project:, status: :cancelled

        travel_to 5.days.from_now do
          ExpireTaskJob.perform_now task

          expect(task.reload.status).to eq 'cancelled'
        end
      end

      it 'quando está finalizado' do
        project = create :project
        contributor = create :user, cpf: '979.612.040-24'
        user_role = create :user_role, project:, user: contributor, role: :contributor
        task = create :task, due_date: 5.days.from_now, user_role:, project:, status: :finished

        travel_to 5.days.from_now do
          ExpireTaskJob.perform_now task

          expect(task.reload.status).to eq 'finished'
        end
      end

      it 'e a tarefa foi criada com prazo e depois foi alterada para sem prazo' do
        project = create :project
        contributor = create :user, cpf: '979.612.040-24'
        user_role = create :user_role, project:, user: contributor, role: :contributor
        task = create :task, due_date: 5.days.from_now, user_role:, project:, status: :uninitialized

        task.update(due_date: nil)

        travel_to 1.day.from_now do
          ExpireTaskJob.perform_now task
          expect(task.reload.expired?).to eq false
        end
      end
    end
  end
end
