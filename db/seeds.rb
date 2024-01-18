user = FactoryBot.create(:user, email: 'usuario1@email.com', password: '123456', cpf: '242.168.390-45')
FactoryBot.create(:profile, user:, first_name: 'Ana', last_name: 'Silva',
                            work_experience: 'Analista de Marketing', education: 'Bacharel em Administração')

user = FactoryBot.create(:user, email: 'usuario2@email.com', password: '123456', cpf: '646.386.700-40')
FactoryBot.create(:profile, user:, first_name: 'Mariana', last_name: 'Costa',
                            work_experience: 'Consultora Financeira', education: 'Mestrado em Economia')

user = FactoryBot.create(:user, email: 'usuario3@email.com', password: '123456', cpf: '293.912.970-30')
FactoryBot.create(:profile, user:, first_name: '', last_name: '',
                            work_experience: '', education: '')
