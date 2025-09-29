class User < ActiveRecord::Base
  has_secure_password   # exige o campo password_digest no banco

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
