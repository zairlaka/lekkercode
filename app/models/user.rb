class User < ApplicationRecord
  audited only: :archive

  has_secure_password

  validates :email,
    presence: true,
    uniqueness: true
end
