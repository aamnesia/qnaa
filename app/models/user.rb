class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards
  has_many :votes, dependent: :destroy
  has_many :comments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(object)
    id == object.user_id
  end
end
