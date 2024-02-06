class Project < ApplicationRecord
  belongs_to :user
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  has_many :tasks, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :meetings, dependent: :destroy
  has_many :project_job_categories, dependent: :destroy

  validates :title, :description, :category, presence: true

  after_create :set_leader_on_create

  def admin?(user)
    member?(user) && user_roles.find_by(user:).admin?
  end

  def member?(user)
    user_roles.find_by(user:).present?
  end

  def future_meetings
    meetings.order(datetime: :asc).where('datetime > ?', Date.current)
  end

  def leader?(user)
    member?(user) && user_roles.find_by(user:).leader?
  end

  def member_roles(role)
    return unless UserRole.roles.keys.include? role.to_s

    user_roles.where(role:).includes(:user)
  end

  private

  def set_leader_on_create
    role = user.user_roles.build(role: :leader)
    role.project = self
    role.save
  end
end
