require 'rails_helper'

RSpec.describe Proposal, type: :model do
  context '#valid?' do
    it 'falso se projeto não existe' do
      proposal = Proposal.new(project_id: 999)

      expect(proposal).not_to be_valid
      expect(proposal.errors).to include :project
      expect(proposal.errors.full_messages).to include 'Projeto é obrigatório(a)'
    end

    it 'falso se id de projeto for vazio' do
      proposal = Proposal.new(project_id: '')

      expect(proposal).not_to be_valid
      expect(proposal.errors).to include :project
      expect(proposal.errors.full_messages).to include 'Projeto é obrigatório(a)'
    end

    it 'falso se portfoliorrr_proposal_id for vazia' do
      proposal = Proposal.new(portfoliorrr_proposal_id: '')

      expect(proposal).not_to be_valid
      expect(proposal.errors).to include :portfoliorrr_proposal_id
      expect(proposal.errors.full_messages).to include 'ID de Solicitação não pode ficar em branco'
    end

    it 'falso se portfoliorrr_proposal_id for menor ou igual a zero' do
      proposal = Proposal.new(portfoliorrr_proposal_id: -1)

      expect(proposal).not_to be_valid
      expect(proposal.errors).to include :portfoliorrr_proposal_id
      expect(proposal.errors.full_messages).to include 'ID de Solicitação deve ser maior ou igual a 1'
    end

    it 'falso se email for vazio' do
      proposal = Proposal.new(email: '')

      expect(proposal).not_to be_valid
      expect(proposal.errors).to include :email
      expect(proposal.errors.full_messages).to include 'E-mail não pode ficar em branco'
    end

    it 'falso se id de perfil for vazio' do
      proposal = Proposal.new(profile_id: '')

      expect(proposal).not_to be_valid
      expect(proposal.errors).to include :profile_id
      expect(proposal.errors.full_messages).to include 'ID de Perfil não pode ficar em branco'
    end

    it 'falso se id de perfil igual ou menor que zero' do
      proposal = Proposal.new(profile_id: -1)

      expect(proposal).not_to be_valid
      expect(proposal.errors).to include :profile_id
      expect(proposal.errors.full_messages).to include 'ID de Perfil deve ser maior ou igual a 1'
    end

    it 'verdadeiro se mensagem estiver em branco' do
      proposal = Proposal.new(message: '')

      proposal.valid?

      expect(proposal.errors).not_to include :message
    end

    it 'verdadeiro se os parâmetros são válidos' do
      project = create :project
      proposal = Proposal.new(
        profile_id: 5,
        project:,
        portfoliorrr_proposal_id: 3,
        message: 'Me aceita',
        email: 'proposal@email.com'
      )

      expect(proposal).to be_valid
    end
  end

  context '#pending!' do
    it 'altera para pending se status for processing' do
      proposal = build :proposal, status: :processing

      proposal.pending!

      expect(proposal.pending?).to be true
    end

    it 'mantém status se este for accepted' do
      proposal = build :proposal, status: :accepted

      proposal.pending!

      expect(proposal.pending?).to be false
    end

    it 'mantém status se este for declined' do
      proposal = build :proposal, status: :declined

      proposal.pending!

      expect(proposal.pending?).to be false
    end

    it 'mantém status se este for cancelled' do
      proposal = build :proposal, status: :cancelled

      proposal.pending!

      expect(proposal.pending?).to be false
    end
  end

  context '#accepted!' do
    it 'altera para accepted se status for pending' do
      proposal = build :proposal, status: :pending

      proposal.accepted!

      expect(proposal.accepted?).to be true
    end

    it 'mantém status se este for processing' do
      proposal = build :proposal, status: :processing

      proposal.accepted!

      expect(proposal.accepted?).to be false
    end

    it 'mantém status se este for declined' do
      proposal = build :proposal, status: :declined

      proposal.accepted!

      expect(proposal.accepted?).to be false
    end

    it 'mantém status se este for cancelled' do
      proposal = build :proposal, status: :cancelled

      proposal.accepted!

      expect(proposal.accepted?).to be false
    end
  end

  context '#declined!' do
    it 'altera para declined se status for processing' do
      proposal = build :proposal, status: :processing

      proposal.declined!

      expect(proposal.declined?).to be true
    end

    it 'mantém status se este for accepted' do
      proposal = build :proposal, status: :accepted

      proposal.declined!

      expect(proposal.declined?).to be false
    end

    it 'mantém status se este for pending' do
      proposal = build :proposal, status: :pending

      proposal.declined!

      expect(proposal.declined?).to be false
    end

    it 'mantém status se este for cancelled' do
      proposal = build :proposal, status: :cancelled

      proposal.declined!

      expect(proposal.declined?).to be false
    end
  end

  context '#processing!' do
    it 'altera para processing se status for pending' do
      proposal = build :proposal, status: :pending

      proposal.processing!

      expect(proposal.processing?).to be true
    end

    it 'mantém status se este for accepted' do
      proposal = build :proposal, status: :accepted

      proposal.processing!

      expect(proposal.processing?).to be false
    end

    it 'mantém status se este for declined' do
      proposal = build :proposal, status: :declined

      proposal.processing!

      expect(proposal.processing?).to be false
    end

    it 'mantém status se este for cancelled' do
      proposal = build :proposal, status: :cancelled

      proposal.processing!

      expect(proposal.processing?).to be false
    end
  end

  context '#cancelled!' do
    it 'altera para cancelled se status for pending' do
      proposal = build :proposal, status: :pending

      proposal.cancelled!

      expect(proposal.cancelled?).to be true
    end

    it 'mantém status se este for accepted' do
      proposal = build :proposal, status: :accepted

      proposal.cancelled!

      expect(proposal.cancelled?).to be false
    end

    it 'mantém status se este for declined' do
      proposal = build :proposal, status: :declined

      proposal.cancelled!

      expect(proposal.cancelled?).to be false
    end

    it 'mantém status se este for processing' do
      proposal = build :proposal, status: :processing

      proposal.cancelled!

      expect(proposal.cancelled?).to be false
    end
  end
end
