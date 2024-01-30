class Project < ApplicationRecord
  belongs_to :user
  has_many :user_roles, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :meetings, dependent: :destroy

  validates :title, :description, :category, presence: true

  after_create :set_leader_on_create

  def member?(user)
    user_roles.find_by(user:).present?
  end

  def future_meetings
    meetings.order(datetime: :asc).where('datetime > ?', Date.current)
  end

  def leader?(user)
    member?(user) && user_roles.find_by(user:).leader?
  end

  def leader
    user_roles.find_by(role: :leader).user
  end

  def admins
    user_roles.where(role: :admin)
              .includes(:user)
              .map(&:user)
  end

  def contributors
    user_roles.where(role: :contributor)
              .includes(:user)
              .map(&:user)
  end

  private

  def set_leader_on_create
    role = user.user_roles.build(role: :leader)
    role.project = self
    role.save
  end
end
