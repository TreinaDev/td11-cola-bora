class Meeting < ApplicationRecord
  belongs_to :user_role
  belongs_to :project

  validates :title, :datetime, :duration, :address, presence: true
end
