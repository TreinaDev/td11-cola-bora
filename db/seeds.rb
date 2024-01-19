# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


ash = FactoryBot.create(:user, email: 'ash@email.com')
brock = FactoryBot.create(:user, email: 'brock@email.com', cpf: '000.000.001-91')

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