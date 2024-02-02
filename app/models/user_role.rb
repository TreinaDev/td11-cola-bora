class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :project

  enum role: { contributor: 1, admin: 5, leader: 9 }

  validate :only_one_leader_per_project

  default_scope { where(active: true) }

  def self.get_user_role(project, user)
    UserRole.find_by(user:, project:)
  end

  private

  def only_one_leader_per_project
    return unless project.user_roles.any?

    project.user_roles.each do |user_role|
      errors.add(:project, I18n.t(:one_leader)) if leader? && user_role.leader?
    end
  end
end
