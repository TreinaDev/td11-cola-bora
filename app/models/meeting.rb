class Meeting < ApplicationRecord
  belongs_to :user_role
  belongs_to :project
end
