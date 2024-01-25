class Project < ApplicationRecord
  belongs_to :user
  has_many :user_roles, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :meetings, dependent: :destroy

  validates :title, :description, :category, presence: true

  after_create :set_leader_on_create

  def member?(user)
    UserRole.find_by(user:, project: self).present?
  end

  def future_meetings
    meetings.order(datetime: :asc).where('datetime > ?', Date.current)
  end

  private

  def set_leader_on_create
    role = user.user_roles.build(role: :leader)
    role.project = self
    role.save
  end
end
