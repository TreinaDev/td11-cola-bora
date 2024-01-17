class Profile < ApplicationRecord
  belongs_to :user

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_update?
    attributes.except('user_id', 'id', 'created_at', 'updated_at').each_value do |v|
      return false if v != ''
    end

    true
  end
end
