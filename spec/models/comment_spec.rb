require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#valid?' do
    context 'false' do
      it 'conteúdo é obrigatório' do
        leader = create :user, email: 'leader@email.com'
        project = create :project, user: leader, title: 'Projeto Top'
        leader_role = UserRole.last
        post = create :post, user_role: leader_role, project:, title: 'Post Top'
        comment = build :comment, content: '', post:, user_role: leader_role

        comment.valid?

        expect(comment.errors.include?(:content)).to be true
        expect(comment.errors[:content]).to include 'não pode ficar em branco'
        expect(Comment.count).to eq 0
      end
    end
  end
end
