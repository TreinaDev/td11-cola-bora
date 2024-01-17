require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'falso sem CPF' do
        user = User.new(cpf: '')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'falso sem e-mail' do
        user = User.new(email: '')

        expect(user.valid?).to be false
        expect(user.errors).to include :email
      end

      it 'falso sem senha' do
        user = User.new(password: '')

        expect(user.valid?).to be false
        expect(user.errors).to include :password
      end
    end
  end
end
