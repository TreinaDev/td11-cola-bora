FactoryBot.define do
  factory :task do
    title { 'Bugfix' }
    description { 'Fix de um bug' }
    project
    author { User.last }
    assigned { User.last }
    due_date { 10.days.from_now.to_date }
  end
end
