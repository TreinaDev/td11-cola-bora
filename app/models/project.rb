class Project < ApplicationRecord
  belongs_to :user
  has_many :user_roles, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :invitations, dependent: :destroy

  validates :title, :description, :category, presence: true
end
