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

    context 'presence' do
      it 'email não pode ficar em branco' do
        invitation = FactoryBot.build(:invitation, profile_email: '')

        invitation.valid?

        expect(invitation.errors[:profile_email]).to include 'não pode ficar em branco'
      end
    end

    context '#check_pending_invitation' do
      it 'retorna false se a combinação ja existe' do
        project = create :project
        profile_id = 123
        create :invitation, project:, profile_id:, status: :pending, profile_email: 'invited@email.com'

        new_invitation = Invitation.new(project:, profile_id:, status: :pending)

        expect(new_invitation.valid?).to be false
        expect(new_invitation.errors[:base]).to include 'Esse usuário possui convite pendente'
      end

      it 'retorna true se se a combinação não existe' do
        leader = create :user
        project = create :project, user: leader
        profile_id = 11
        create :invitation, project:, profile_id:, status: :pending, profile_email: 'invited@email.com'

        other_project = create :project, user: leader, title: 'Outro Projeto'
        new_invitation = Invitation.new(project: other_project, profile_id:, status: :pending,
                                        profile_email: 'invited@email.com')

        expect(new_invitation.valid?).to be true
        expect(new_invitation.errors[:base]).not_to include 'Esse usuário possui convite pendente'
      end
    end

    context '#check_member' do
      it 'falso se usuário já for membro do projeto' do
        leader = create(:user, cpf: '000.000.001-91')
        project = create(:project, user: leader)
        user = create(:user, email: 'joão@email.com')
        create(:user_role, user:, project:)
        invitation = build(:invitation, project:, profile_email: user.email)

        expect(invitation.valid?).to be false
        expect(invitation.errors[:base]).to include 'Este usuário já faz parte do projeto.'
      end

      it 'verdadeiro se usuário não for membro do projeto' do
        leader = create(:user, cpf: '000.000.001-91')
        project = create(:project, user: leader)
        second_project = create(:project, user: leader, title: 'Second Project')
        user = create(:user, email: 'joão@email.com')
        create(:invitation, project: second_project, profile_email: user.email)

        invitation = build(:invitation, project:, profile_email: user.email)

        expect(invitation.valid?).to be true
      end
    end
  end

  describe '#cancelled?' do
    it 'retorna verdadeiro se tentar mudar de processing para cancelled' do
      invitation = build(:invitation, status: :processing)

      invitation.cancelled!

      expect(invitation.cancelled?).to eq true
    end

    it 'retorna falso se tentar mudar de accepted para cancelled' do
      invitation = build(:invitation, status: :accepted)

      invitation.cancelled!

      expect(invitation.cancelled?).to eq false
    end

    it 'retorna falso se tentar mudar de expired para cancelled' do
      invitation = build(:invitation, status: :expired)

      invitation.cancelled!

      expect(invitation.cancelled?).to eq false
    end

    context 'retorna verdadeiro se tentar mudar de cancelled para qualquer outro' do
      it 'de cancelled para pending' do
        invitation = build(:invitation, status: :cancelled)

        invitation.pending!

        expect(invitation.cancelled?).to eq true
      end

      it 'de cancelled para pending com outro convite pendente' do
        project = create(:project)
        first_invitation = create(:invitation, profile_id: 1, status: :cancelled, project:,
                                               profile_email: 'joão@email.com')
        create(:invitation, profile_id: 1, status: :pending, project:)

        first_invitation.pending!

        expect(first_invitation.cancelled?).to eq true
      end

      it 'de cancelled para expired' do
        invitation = build(:invitation, status: :cancelled)

        invitation.expired!

        expect(invitation.cancelled?).to eq true
      end
    end
  end

  describe '#expired?' do
    context 'retorna verdadeiro se tentar mudar de expired' do
      it 'para pending' do
        invitation = build(:invitation, status: :expired)

        invitation.pending!

        expect(invitation.expired?).to eq true
      end

      it 'para cancelled' do
        invitation = build(:invitation, status: :expired)

        invitation.cancelled!

        expect(invitation.expired?).to eq true
      end
    end
  end

  describe '#validate_expiration_days' do
    it 'muda status para expired quando convite está vencido' do
      invitation = create(:invitation, status: :pending, expiration_days: 5, profile_email: 'joão@email.com')

      travel_to 8.days.from_now do
        invitation.validate_expiration_days

        expect(invitation.reload.expired?).to eq true
      end
    end
  end

  describe '#accepted?' do
    it 'altera status se estiver pending' do
      invitation = build(:invitation, status: :pending)

      invitation.accepted!

      expect(invitation.accepted?).to eq true
    end

    it 'não altera status se estiver declined' do
      invitation = build(:invitation, status: :declined)

      invitation.accepted!

      expect(invitation.accepted?).to eq false
    end

    it 'não altera status se estiver cancelled' do
      invitation = build(:invitation, status: :cancelled)

      invitation.accepted!

      expect(invitation.accepted?).to eq false
    end

    it 'não altera status se estiver expired' do
      invitation = build(:invitation, status: :expired)

      invitation.accepted!

      expect(invitation.accepted?).to eq false
    end

    it 'não altera status se estiver processing' do
      invitation = build(:invitation, status: :processing)

      invitation.accepted!

      expect(invitation.accepted?).to eq false
    end
  end

  describe '#declined?' do
    it 'altera status se estiver pending' do
      invitation = build(:invitation, status: :pending)

      invitation.declined!

      expect(invitation.declined?).to eq true
    end

    it 'não altera status se estiver accepted' do
      invitation = build(:invitation, status: :accepted)

      invitation.declined!

      expect(invitation.declined?).to eq false
    end

    it 'não altera status se estiver cancelled' do
      invitation = build(:invitation, status: :cancelled)

      invitation.declined!

      expect(invitation.declined?).to eq false
    end

    it 'não altera status se estiver expired' do
      invitation = build(:invitation, status: :expired)

      invitation.declined!

      expect(invitation.declined?).to eq false
    end

    it 'não altera status se estiver processing' do
      invitation = build(:invitation, status: :processing)

      invitation.declined!

      expect(invitation.declined?).to eq false
    end
  end

  describe '#pending?' do
    it 'altera status se estiver processing' do
      invitation = build(:invitation, status: :processing)

      invitation.pending!

      expect(invitation.pending?).to eq true
    end

    it 'não altera status se estiver accepted' do
      invitation = build(:invitation, status: :accepted)

      invitation.pending!

      expect(invitation.pending?).to eq false
    end

    it 'não altera status se estiver declined' do
      invitation = build(:invitation, status: :declined)

      invitation.pending!

      expect(invitation.pending?).to eq false
    end

    it 'não altera status se estiver cancelled' do
      invitation = build(:invitation, status: :cancelled)

      invitation.pending!

      expect(invitation.pending?).to eq false
    end

    it 'não altera status se estiver expired' do
      invitation = build(:invitation, status: :expired)

      invitation.pending!

      expect(invitation.pending?).to eq false
    end

    describe '#processing?' do
      it 'altera status se estiver pending' do
        invitation = build(:invitation, status: :pending)

        invitation.processing!

        expect(invitation.processing?).to eq true
      end

      it 'não altera status se estiver cancelled' do
        invitation = build(:invitation, status: :cancelled)

        invitation.processing!

        expect(invitation.processing?).to eq false
      end

      it 'não altera status se estiver accepted' do
        invitation = build(:invitation, status: :accepted)

        invitation.processing!

        expect(invitation.processing?).to eq false
      end

      it 'não altera status se estiver declined' do
        invitation = build(:invitation, status: :declined)

        invitation.processing!

        expect(invitation.processing?).to eq false
      end

      it 'não altera status se estiver expired' do
        invitation = build(:invitation, status: :expired)

        invitation.processing!

        expect(invitation.processing?).to eq false
      end
    end
  end

  describe '#expiration_date' do
    it 'calcula a data de validade ao ser criado' do
      invitation = create(:invitation, expiration_days: 5, profile_email: 'joão@email.com')

      expect(invitation.expiration_date).to eq 5.days.from_now.to_date
    end

    it 'data de validade é vazia se expiration_days for vazia' do
      invitation = create(:invitation, expiration_days: '', profile_email: 'joão@email.com')

      expect(invitation.expiration_date).to be nil
    end
  end

  describe '#accept_proposal' do
    it 'Muda status de uma solicitação de pendente para aceita' do
      project = create :project
      invitation = build :invitation,
                         project:,
                         profile_id: 1,
                         profile_email: 'user@email.com',
                         status: :pending
      proposal = create :proposal,
                        project:,
                        status: :pending,
                        profile_id: 1,
                        email: 'user@email'

      invitation.accept_proposal

      expect(proposal.reload.status).to eq 'accepted'
    end

    it 'Não muda status de uma solicitação de cancelada para aceita' do
      project = create :project
      invitation = build :invitation,
                         project:,
                         profile_id: 1,
                         profile_email: 'user@email.com',
                         status: :pending
      proposal = create :proposal,
                        project:,
                        status: :cancelled,
                        profile_id: 1,
                        email: 'user@email.com'

      invitation.accept_proposal

      expect(proposal.reload.status).not_to eq 'accepted'
      expect(proposal.reload.status).to eq 'cancelled'
    end

    it 'Não muda status de uma solicitação recusada para aceita' do
      project = create :project
      invitation = build :invitation,
                         project:,
                         profile_id: 1,
                         profile_email: 'user@email.com',
                         status: :pending
      proposal = create :proposal,
                        project:,
                        status: :declined,
                        profile_id: 1,
                        email: 'user@email.com'

      invitation.accept_proposal

      expect(proposal.reload.status).not_to eq 'accepted'
      expect(proposal.reload.status).to eq 'declined'
    end
  end
end
