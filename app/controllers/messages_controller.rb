class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.create(user: current_user, **message_params)
    @message.user = current_user

    if @message.save!
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.append("chat-box", partial: "messages/message", locals: { message: @message }) }
        format.html { redirect_to @channel, notice: "Message sent successfully" }
      end
    else
      render turbo_stream: turbo_stream.replace("message_#{@message.id}", partial: "messages/message", locals: { message: @message })
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
