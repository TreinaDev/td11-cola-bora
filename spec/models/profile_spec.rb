require 'rails_helper'

RSpec.describe Profile, type: :model do
  context '#first_update?' do
    it 'retorna true com quando nenhum campo foi preenchido' do
      user = create(:user)
      user.profile.update(first_name: '', last_name: '', work_experience: '',
                          education: '')

      expect(user.profile.first_update?).to be true
    end

    it 'retorna falso com pelo menos o nome preenchido' do
      user = create(:user)
      user.profile.update(first_name: 'Carlos', last_name: '', work_experience: '',
                          education: '')

      expect(user.profile.first_update?).to be false
    end

    it 'retorna falso com pelo menos o sobrenome preenchido' do
      user = create(:user)
      user.profile.update(first_name: '', last_name: 'Andrade', work_experience: '',
                          education: '')

      expect(user.profile.first_update?).to be false
    end

    it 'retorna falso com pelo menos a experiência de profissional preenchida' do
      user = create(:user)
      user.profile.update(first_name: '', last_name: '',
                          work_experience: 'Consultor financeiro', education: '')

      expect(user.profile.first_update?).to be false
    end

    it 'retorna falso com pelo menos a informação acadêmica preenchido' do
      user = create(:user)
      user.profile.update(first_name: '', last_name: '',
                          work_experience: '', education: 'Engenharia civil')

      expect(user.profile.first_update?).to be false
    end
  end

  context '#full_name' do
    context 'retorna uma string' do
      it 'com nome e sobrenome' do
        user = create(:user)
        user.profile.update(first_name: 'Carlos', last_name: 'Andrade')

        expect(user.profile.full_name).to eq 'Carlos Andrade'
      end

      it 'com apenas nome' do
        user = create(:user)
        user.profile.update(first_name: 'Carlos', last_name: '')

        expect(user.profile.full_name).not_to eq 'Carlos '
        expect(user.profile.full_name).to eq 'Carlos'
      end

      it 'com apenas sobrenome' do
        user = create(:user)
        user.profile.update(first_name: '', last_name: 'Pereira')

        expect(user.profile.full_name).not_to eq ' Pereira'
        expect(user.profile.full_name).to eq 'Pereira'
      end
    end
  end
end
