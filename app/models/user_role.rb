class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :project

  enum role: { contributor: 1, admin: 5, leader: 9 }
end
