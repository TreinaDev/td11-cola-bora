class Profile < ApplicationRecord
  belongs_to :user

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_update?
    attributes.slice('first_name', 'last_name', 'work_experience', 'education').each_value do |v|
      return false unless v.empty?
    end

    true
  end
end
