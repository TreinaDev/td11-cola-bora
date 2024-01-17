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

    context 'CPF válido' do
      it 'falso com CPF inválido com formatação' do
        user = User.new(cpf: '123.456.789-00')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'falso com CPF inválido sem formatação' do
        user = User.new(cpf: '12345678900')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'verdadeiro com CPF válido com formatação' do
        user = User.new(cpf: '125.445.890-51')

        user.valid?

        expect(user.errors).not_to include :cpf
      end

      it 'verdadeiro com CPF válido sem formatação' do
        user = User.new(cpf: '12544589051')

        user.valid?

        expect(user.errors).not_to include :cpf
      end
    end
  end
end
