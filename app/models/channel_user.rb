class ChannelUser < ApplicationRecord
  belongs_to :channel
  belongs_to :user

  # Ensure a user can only join a channel once
  validates :user_id, uniqueness: { scope: :channel_id }
end
