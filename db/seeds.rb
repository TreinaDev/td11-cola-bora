ash = FactoryBot.create(:user, email: 'ash@email.com', cpf: '837.513.746-47')
FactoryBot.create(:profile, user: ash, first_name: 'Ash', last_name: 'Ketchum',
                            work_experience: 'Treinador Pokemon', education: 'Escola Pokemon')
brock = FactoryBot.create(:user, email: 'brock@email.com', cpf: '000.000.001-91')
FactoryBot.create(:profile, user: brock, first_name: 'Brock', last_name: '',
                            work_experience: 'Treinador de Pokemon de rocha', education: 'Escola Pokemon')
misty = FactoryBot.create(:user, email: 'misty@email.com', cpf: '293.912.970-30')
FactoryBot.create(:profile, user: misty, first_name: '', last_name: '',
                            work_experience: '', education: '')

FactoryBot.create(:project, user: ash)
pokemon_project = FactoryBot.create(:project, user: brock, title: 'Líder de Ginásio', 
                                              description: 'Me tornar líder do estádio de pedra.',
                                              category: 'Auto Ajuda') 

FactoryBot.create(:task, project: pokemon_project, title:'Pegar um geodude', 
                         description:'Para completar o meu time de pedra, preciso de um geodude, vamos captura-lo',
                         assigned: brock, due_date: 2.months.from_now.to_date, author: brock)

FactoryBot.create(:task, project: pokemon_project, title:'Parar a equipe rocket', 
                         description:'A equipe rocket está aprontando novamente, temos que para-los',
                         assigned: ash, due_date: Time.zone.tomorrow, author: ash)

FactoryBot.create(:task, project: pokemon_project, title:'Derrotar um Charmander',
                         description: 'Lutar contra outro treinador com um Charmander.',
                         assigned: ash, due_date: 1.week.from_now, author: ash)
