class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  validates :content, presence: true

  # Automatically broadcast changes to subscribers
  after_create_commit -> {
    broadcast_append_to "channel_#{channel.id}_#{channel.name}",
                        target: "chat-box",
                        partial: "messages/message"
    user.update(last_sent_at: Time.zone.now)
  }
end
