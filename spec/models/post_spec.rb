require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#Valid?' do
    context 'presence' do
      it 'Título não pode ficar em branco' do
        post = FactoryBot.build(:post, title: '')

        post.valid?

        expect(post.errors.full_messages).to include 'Título não pode ficar em branco'
        expect(post.valid?).to eq false
      end

      it 'Corpo não pode ficar em branco' do
        post = FactoryBot.build(:post, body: '')

        post.valid?

        expect(post.errors.full_messages).to include 'Corpo não pode ficar em branco'
        expect(post.valid?).to eq false
      end
    end
  end
end
