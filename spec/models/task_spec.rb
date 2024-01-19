require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#valido?' do
    context 'presença' do
      it 'falso quando título está vazio' do
        task = FactoryBot.build(:task, title: '')

        task.valid?

        expect(task.errors[:title]).to include 'não pode ficar em branco'
      end

      it 'falso quando projeto está vazio' do
        task = FactoryBot.build(:task, project_id: '')

        task.valid?

        expect(task.errors[:project]).to include 'é obrigatório(a)'
      end

      it 'falso quando autor está vazio' do
        task = FactoryBot.build(:task, author_id: '')

        task.valid?

        expect(task.errors[:author]).to include 'é obrigatório(a)'
      end
    end

    context 'prazo deve ser futuro' do
      it 'falso se data é no passado' do
        task = FactoryBot.build(:task, due_date: 1.day.ago.to_date)

        task.valid?

        expect(task.errors[:due_date]).to include ' deve ser futuro.'
      end

      it 'verdadeiro se data é hoje' do
        task = FactoryBot.build(:task, due_date: Time.zone.today)

        task.valid?

        expect(task.errors[:due_date]).not_to include ' deve ser futuro.'
      end

      it 'verdadeiro se data é no futuro' do
        task = FactoryBot.build(:task, due_date: 1.day.from_now.to_date)

        task.valid?

        expect(task.errors[:due_date]).not_to include ' deve ser futuro.'
      end
    end
  end
end
