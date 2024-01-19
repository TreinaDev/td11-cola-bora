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
FactoryBot.create(:project, user: brock, title: 'Líder de Ginásio', description: 'Me tornar líder do estádio de pedra.', category: 'Auto Ajuda') 