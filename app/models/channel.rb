class Channel < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :channel_users, dependent: :destroy
  has_many :users, through: :channel_users

  validates :name, presence: true, uniqueness: true
end
