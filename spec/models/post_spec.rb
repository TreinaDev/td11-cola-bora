require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#Valid?' do
    context 'presence' do
      it 'Título não pode ficar em branco' do
        post = FactoryBot.build(:post, title: '')

        expect(post.valid?).to eq false
        expect(post.errors.full_messages).to include 'Título não pode ficar em branco'
      end

      it 'Corpo não pode ficar em branco' do
        post = FactoryBot.build(:post, body: '')

        expect(post.valid?).to eq false
        expect(post.errors.full_messages).to include 'Corpo não pode ficar em branco'
      end
    end
  end
end
