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

    context 'uniqueness' do
      it 'falso com CPF já utilizado' do
        create(:user, cpf: '568.064.040-65')
        user = User.new(cpf: '568.064.040-65')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'falso com e-mail já utilizado' do
        create(:user, email: 'usuario@email.com')
        user = User.new(email: 'usuario@email.com')

        expect(user.valid?).to be false
        expect(user.errors).to include :email
      end
    end
  end
end
