class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :user_roles, dependent: :destroy

  validates :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :validate_cpf

  after_create :create_profile

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def create_profile
    self.profile = Profile.new
  end

  def validate_cpf
    errors.add(:cpf, 'inválido') unless CPF.valid?(cpf)
  end
end
