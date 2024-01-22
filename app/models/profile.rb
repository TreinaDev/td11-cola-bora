class Profile < ApplicationRecord
  belongs_to :user

  def full_name
    return first_name if last_name.blank?
    return last_name if first_name.blank?

    "#{first_name} #{last_name}"
  end

  def first_update?
    attributes.slice('first_name', 'last_name', 'work_experience', 'education').each_value do |v|
      return false if v.present?
    end

    true
  end
end
