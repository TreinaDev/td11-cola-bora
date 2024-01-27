require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe '#valid?' do
    context 'expiration_days' do
      it 'retorna falso se expiration_days é menor que zero' do
        invitation = build(:invitation, expiration_days: -1)

        expect(invitation).not_to be_valid
        expect(invitation.errors[:expiration_days]).to include 'deve ser maior ou igual a 0'
      end
    end
  end

  describe '#cancelled?' do
    it 'retorna verdadeiro se tentar mudar de pending para cancelled' do
      invitation = build(:invitation, status: :pending)

      invitation.cancelled!

      expect(invitation.cancelled?).to be_truthy
    end

    it 'retorna falso se tentar mudar de accepted para cancelled' do
      invitation = build(:invitation, status: :accepted)

      invitation.cancelled!

      expect(invitation.cancelled?).to be_falsy
    end

    it 'retorna falso se tentar mudar de expired para cancelled' do
      invitation = build(:invitation, status: :expired)

      invitation.cancelled!

      expect(invitation.cancelled?).to be_falsy
    end

    context 'retorna verdadeiro se tentar mudar de cancelled para qualquer outro' do
      it 'de cancelled para pending' do
        invitation = build(:invitation, status: :cancelled)

        invitation.pending!

        expect(invitation.cancelled?).to be_truthy
      end

      it 'de cancelled para expired' do
        invitation = build(:invitation, status: :cancelled)

        invitation.expired!

        expect(invitation.cancelled?).to be_truthy
      end
    end
  end

  describe '#expired?' do
    context 'retorna verdadeiro se tentar mudar de expired para qualquer outro' do
      it 'de expired para pending' do
        invitation = build(:invitation, status: :expired)

        invitation.pending!

        expect(invitation.expired?).to be_truthy
      end

      it 'de expired para cancelled' do
        invitation = build(:invitation, status: :expired)

        invitation.cancelled!

        expect(invitation.expired?).to be_truthy
      end
    end
  end

  describe '#validate_expiration_days' do
    it 'muda status para expired quando convite está vencido' do
      invitation = create(:invitation, status: :pending, expiration_days: 5)

      travel_to 8.days.from_now do
        invitation.validate_expiration_days

        expect(invitation.reload.expired?).to be_truthy
      end
    end
  end
end
