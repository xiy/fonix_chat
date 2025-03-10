class ChatChannel < ApplicationCable::Channel
  include Turbo::Streams::ActionHelper
  include ActionView::Helpers::TagHelper

  def subscribed
    channel = Channel.find(params[:id])
    return reject unless channel.users.include?(current_user)

    stream_name = "channel_#{channel.id}_#{channel.name}"
    Rails.logger.info "User #{current_user.id} subscribing to #{stream_name}"

    # This connects the ActionCable channel to Turbo Streams
    stream_from stream_name
  end

  def unsubscribed
    Rails.logger.info "User #{current_user.id} unsubscribed"
  end

  def receive(data)
    channel = Channel.find(params[:id])
    return reject unless channel.users.include?(current_user)

    # Just create the message, the model callback will handle broadcasting
    channel.messages.create!(content: data["message"], user: current_user)
  end
end
