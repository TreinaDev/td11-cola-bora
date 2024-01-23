require 'rails_helper'

RSpec.describe UserRole, type: :model do
  describe '#valid?' do
    context 'limite de papeis' do
      it 'só pode ter um líder' do
        user = create :user
        project = create(:project, user:)
        user_role = UserRole.new(user:, project:, role: 'leader')

        user_role.valid?

        expect(project.user_roles.count).to eq 1
        expect(user_role.errors.include?(:project)).to be true
        expect(user_role.errors.full_messages).to include 'Projeto aceita apenas 1 líder'
      end
    end
  end
end
