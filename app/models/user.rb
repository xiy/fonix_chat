class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages
  has_many :channel_users
  has_many :channels, through: :channel_users

  def messages_since_last_sent
    Message.where(channel_id: channels.pluck(:id))
      .where("created_at > ?", last_sent_at)
      .where.not(user_id: id)
      .where("created_at > ?", messages.maximum(:created_at) || last_sent_at)
  end
end
