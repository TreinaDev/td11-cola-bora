require 'rails_helper'

RSpec.describe Profile, type: :model do
  context '#first_update?' do
    it 'retorna true com quando nenhum campo foi preenchido' do
      profile = create(:profile, first_name: '', last_name: '', work_experience: '',
                                 education: '')

      expect(profile.first_update?).to be true
    end

    it 'retorna falso com pelo menos o nome preenchido' do
      profile = create(:profile, first_name: 'Carlos', last_name: '', work_experience: '',
                                 education: '')

      expect(profile.first_update?).to be false
    end

    it 'retorna falso com pelo menos o sobrenome preenchido' do
      profile = create(:profile, first_name: '', last_name: 'Andrade', work_experience: '',
                                 education: '')

      expect(profile.first_update?).to be false
    end

    it 'retorna falso com pelo menos a experiência de profissional preenchida' do
      profile = create(:profile, first_name: '', last_name: '', work_experience: 'Consultor financeiro',
                                 education: '')

      expect(profile.first_update?).to be false
    end

    it 'retorna falso com pelo menos a informação acadêmica preenchido' do
      profile = create(:profile, first_name: '', last_name: '', work_experience: '',
                                 education: 'Engenharia civil')

      expect(profile.first_update?).to be false
    end
  end

  context '#full_name' do
    it 'retorna a junção do nome e sobrenome' do
      profile = create(:profile, first_name: 'Carlos', last_name: 'Andrade')

      expect(profile.full_name).to eq 'Carlos Andrade'
    end
  end
end
