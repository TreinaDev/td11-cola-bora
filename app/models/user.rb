class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :authored_tasks, foreign_key: 'author_id', dependent: :nullify, inverse_of: :task
  has_many :assigned_tasks, foreign_key: 'assigned_id', dependent: :nullify, inverse_of: :task
  has_many :documents, dependent: :destroy

  validates :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :validate_cpf

  after_create :create_profile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  delegate :full_name, to: :profile

  def can_edit?(item)
    user_role = UserRole.get_user_role(item.project, self)
    item.user_role.user == self || user_role.leader? || user_role.admin?
  end

  def all_projects
    user_roles.map(&:project)
  end

  def my_projects
    user_roles.select { |user_role| user_role.project if user_role.role == 'leader' }.map(&:project)
  end

  def contributing_projects
    user_roles.select { |user_role| user_role.project unless user_role.role == 'leader' }.map(&:project)
  end

  private

  def create_profile
    self.profile = Profile.new
  end

  def validate_cpf
    errors.add(:cpf, I18n.t(:invalid)) unless CPF.valid?(cpf)
  end
end
