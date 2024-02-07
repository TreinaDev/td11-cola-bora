require 'rails_helper'

RSpec.describe ExpiredTaskJob, type: :job do
  describe '#perform' do
    context 'muda para expirado quando excede prazo' do
      it 'e não está iniciado' do
        task = create :task, due_date: 5.days.from_now, status: :uninitialized

        ExpiredTaskJob.perform_now task

        expect(task.reload.status).to eq 'expired'
      end

      it 'e está em andamento' do
        task = create :task, due_date: 5.days.from_now, status: :in_progress

        ExpiredTaskJob.perform_now task

        expect(task.reload.status).to eq 'expired'
      end
    end

    context 'não muda para expirado' do
      it 'quando está cancelado' do
        task = create :task, due_date: 5.days.from_now, status: :cancelled

        ExpiredTaskJob.perform_now task

        expect(task.reload.status).to eq 'cancelled'
      end

      it 'quando está finalizado' do
        task = create :task, due_date: 5.days.from_now, status: :finished

        ExpiredTaskJob.perform_now task

        expect(task.reload.status).to eq 'finished'
      end
    end
  end
end
