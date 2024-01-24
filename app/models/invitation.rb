class Invitation < ApplicationRecord
  belongs_to :project

  validates :project_id, uniqueness: { scope: :profile_id }
end
