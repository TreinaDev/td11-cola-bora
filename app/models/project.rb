class Project < ApplicationRecord
  belongs_to :user
  has_many :user_roles, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :meetings, dependent: :destroy

  validates :title, :description, :category, presence: true

  after_create :set_leader_on_create

  def project_paticipant?(user)
    UserRole.find_by(user:, project: self).present?
  end

  private

  def set_leader_on_create
    role = user.user_roles.build(role: :leader)
    role.project = self
    role.save
  end
end
