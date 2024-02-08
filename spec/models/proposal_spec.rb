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
        message: 'Me aceita',
        email: 'proposal@email.com'
      )

      expect(proposal).to be_valid
    end
  end
end
