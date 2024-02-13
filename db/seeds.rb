user = FactoryBot.create(:user, email: 'user@email.com', cpf: '026.732.930-00',
                         password: '123456')

ash = FactoryBot.create(:user, email: 'ash@email.com', cpf: '837.513.746-47')
ash.profile.update(first_name: 'Ash', last_name: 'Ketchum',
                            work_experience: 'Treinador Pokemon', education: 'Escola Pokemon')

brock = FactoryBot.create(:user, email: 'brock@email.com', cpf: '000.000.001-91')
brock.profile.update(first_name: 'Brock', last_name: 'Harrison',
                            work_experience: 'Treinador Pokemon de rocha', education: 'Escola Pokemon')

misty = FactoryBot.create(:user, email: 'misty@email.com', cpf: '293.912.970-30')
misty.profile.update(first_name: 'Mysty', last_name: '',
                            work_experience: 'Treinadora Pokemon de água', education: 'Escola Pokemon')

professor_carvalho = FactoryBot.create(:user, email: 'oak@email.com', cpf: '168.329.700-80',
                                       password: '123456')
professor_carvalho.profile.update(first_name: 'Marcos', last_name: 'Carvalho',
                                  work_experience: 'Professor', education: 'Universidade Pokemon de Pallet')

jessie = FactoryBot.create(:user, email: 'jessie@email.com', cpf: '871.347.200-39',
                           password: '123456')
jessie.profile.update(first_name: 'Jessie', last_name: 'Carvalho',
                      work_experience: 'Treinadora de Pokemon de veneno', education: 'Supletivo')

james = FactoryBot.create(:user, email: 'james@email.com', cpf: '730.714.300-35',
                          password: '123456')
james.profile.update(first_name: 'James', last_name: 'Rocket',
                     work_experience: 'Totalmente sem intenção de roubar o Pikachu', education: 'Academia Pokemon de Johto')



pikachu_project = FactoryBot.create(:project, user: ash, title: 'Evoluir o Pikachu',
                                              description: 'Vamos transformar o Pikachu em Raichu!',
                                              category: 'Fitness')
pikachu_project.user_roles.create!([{ user: brock },
                                    { user: misty },
                                    { user: professor_carvalho, role: :admin },
                                    { user: james }])

ginasio_project = FactoryBot.create(:project, user: brock, title: 'Líder de Ginásio',
                                              description: 'Me tornar líder do estádio de pedra.',
                                              category: 'Auto Ajuda')
ginasio_project.user_roles.create!([{ user: ash, role: :admin },
                                    { user: misty, role: :admin },
                                    { user: professor_carvalho }])

pokemon_project = FactoryBot.create(:project, user: brock, title: 'Pokedex',
                                              description: 'Fazer uma listagem de todos os pokemons.',
                                              category: 'Tecnologia')
pokemon_project.user_roles.create!([{ user: ash },
                                    { user: misty },
                                    { user: professor_carvalho, role: :admin }])

encrenca_project = FactoryBot.create(:project, user: james, title: 'Encrenca em Dobro',
                                               description: 'Projeto para roubar o Pikachu',
                                               category: 'Secreta')
encrenca_project.user_roles.create!([{ user: jessie, role: :admin }])

ash_project = FactoryBot.create(:project, user: ash, title: 'Pousadaria', category: 'Aplicação WEB')

ash_project2 = FactoryBot.create(:project, user: ash, title: 'Portfoliorr', category: 'Aplicação WEB')

ash_project3 = FactoryBot.create(:project, user: ash, title: 'Arrumar a casa', category: 'Organização')


first_project_job_category = FactoryBot.create(:project_job_category, project: pokemon_project, job_category_id: 1)

second_project_job_category = FactoryBot.create(:project_job_category, project: pokemon_project, job_category_id: 2)

third_project_job_category = FactoryBot.create(:project_job_category, project: encrenca_project, job_category_id: 1)



FactoryBot.create(:task, project: pokemon_project, title:'Pegar um geodude',
                                  description:'Para completar o meu time de pedra, preciso de um geodude, vamos captura-lo',
                                  assigned: brock, due_date: 2.months.from_now.to_date, user_role: ginasio_project.user_roles.first)

FactoryBot.create(:task, project: pokemon_project, title:'Parar a equipe rocket',
                         description:'A equipe rocket está aprontando novamente, temos que para-los',
                         assigned: ash, due_date: Time.zone.tomorrow, user_role: ginasio_project.user_roles.first)

FactoryBot.create(:task, project: pokemon_project, title:'Derrotar um Charmander',
                         description: 'Lutar contra outro treinador com um Charmander.',
                         assigned: ash, due_date: 1.week.from_now, user_role: ginasio_project.user_roles.first)



FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Reunião para planejar a captura do geodude',
                            description:'Para completar o meu time de pedra, preciso de um geodude, vamos captura-lo',
                            datetime: 2.days.from_now, duration: 75, address: 'https://meet.google.com/')

FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Parar a equipe rocket',
                            description:'A equipe rocket está aprontando novamente, temos que para-los',
                            datetime: (2.days.from_now + 2.hours), duration: 50, address: 'https://meet.google.com/')

FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Derrotar um Charmander',
                            description:'Lutar contra outro treinador com um Charmander.',
                            datetime: 5.days.from_now, duration: 120, address: 'https://meet.google.com/')

FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Daily', description:'', datetime: 1.days.from_now, duration: 15,
                            address: 'https://meet.google.com/')

FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Daily', description:'', datetime: 2.days.from_now, duration: 15,
                            address: 'https://meet.google.com/')

FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Daily', description:'', datetime: 3.days.from_now, duration: 15,
                            address: 'https://meet.google.com/')

FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Daily', description:'', datetime: 4.days.from_now, duration: 15,
                            address: 'https://meet.google.com/')

FactoryBot.create(:meeting, project: pokemon_project, user_role: UserRole.find_by(user: brock, project: pokemon_project),
                            title:'Daily', description:'', datetime: 5.days.from_now, duration: 15,
                            address: 'https://meet.google.com/')


FactoryBot.create(:invitation, project: pokemon_project, profile_id: 1,
                               expiration_days: 10, status: :pending)

FactoryBot.create(:invitation, project: ash_project, profile_email: brock.email,
                               message: 'Adoraria que fizesse parte da minha equipe', status: :pending)

FactoryBot.create(:invitation, project: ash_project2, profile_email: brock.email,
                               expiration_days: '', status: :pending)

FactoryBot.create(:invitation, project: ash_project3, profile_email: brock.email,
                               expiration_days: '', status: :processing)

FactoryBot.create(:invitation, project: pikachu_project, expiration_days: 5,
                               profile_id: 90, status: :pending)
FactoryBot.create(:invitation, project: pikachu_project, expiration_days: 7,
                               profile_id: 91, status: :accepted)
FactoryBot.create(:invitation, project: pikachu_project, expiration_days: 10,
                               profile_id: 92, status: :cancelled)
FactoryBot.create(:invitation, project: pikachu_project, expiration_days: nil,
                               profile_id: 93, status: :expired)
FactoryBot.create(:invitation, project: pikachu_project, expiration_days: 2,
                               profile_id: 94, status: :processing)


FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 50,
                             portfoliorrr_proposal_id: 101,
                             status: :pending,
                             email: 'gary@email.com,',
                             message: 'Olá! Gostaria de fazer parte de seu projeto')
FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 51,
                             portfoliorrr_proposal_id: 102,
                              status: :accepted,
                             email: 'misty2@email.com',
                             message: 'Me aceita!!!')
FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 52,
                             portfoliorrr_proposal_id: 103,
                             status: :declined,
                             email: 'jessie_rocket@email.com',
                             message: 'Eu prometo que não quero roubar o Pikachu')
FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 53,
                             portfoliorrr_proposal_id: 104,
                             status: :pending,
                             email: 'ash_ketchum@email.com',
                             message: 'Oi! Estou super interessado no seu projeto, posso ajudar?')
FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 54,
                             portfoliorrr_proposal_id: 105,
                             status: :accepted,
                             email: 'brock_rock@email.com',
                             message: 'Por favor, aceite minha proposta. Estou pronto para começar a trabalhar!')
FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 55,
                             portfoliorrr_proposal_id: 106,
                             status: :cancelled,
                             email: 'professor_oak@email.com',
                             message: 'Infelizmente não posso participar neste momento. Boa sorte com o projeto!')
FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 56,
                             portfoliorrr_proposal_id: 107,
                             status: :pending,
                             email: 'team_rocket@email.com',
                             message: 'Preparem-se para se render, ou enfrentem a nossa ira!')
FactoryBot.create(:proposal, project: pikachu_project,
                             profile_id: 57,
                             portfoliorrr_proposal_id: 108,
                             status: :accepted,
                             email: 'giovanni_boss@email.com',
                             message: 'Aceite minha proposta e sua jornada será bem recompensada!')
