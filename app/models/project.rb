class Project < ApplicationRecord
  belongs_to :user
  has_many :user_roles, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :title, :description, :category, presence: true

  def is_leader?(user)
    self.user_roles.find_by(user: user).leader?
  end
end
