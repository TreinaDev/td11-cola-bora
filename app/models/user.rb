class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :authored_tasks, foreign_key: 'author_id', dependent: :nullify, inverse_of: :task
  has_many :assigned_tasks, foreign_key: 'assigned_id', dependent: :nullify, inverse_of: :task

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
