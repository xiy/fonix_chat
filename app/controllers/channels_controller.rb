class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    @channels = Channel.all
  end

  def show
    @channel = Channel.find(params[:id])

    # Auto-join users who visit the channel
    unless @channel.users.include?(current_user)
      Rails.logger.info "Auto-joining user #{current_user.id} to channel #{@channel.id}"
      @channel.users << current_user
    end

    @messages = @channel.messages.order(created_at: :asc)
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(channel_params)
    if @channel.save
      ChannelUser.create(channel: @channel, user: current_user)
      redirect_to @channel, notice: "Channel created successfully"
    else
      render :new
    end
  end

  def join
    @channel = Channel.find(params[:id])
    ChannelUser.find_or_create_by(channel: @channel, user: current_user)
    redirect_to @channel, notice: "Joined channel #{@channel.name}"
  end

  def leave
    @channel = Channel.find(params[:id])
    ChannelUser.find_by(channel: @channel, user: current_user).destroy!
    redirect_to channels_path, notice: "Left channel #{@channel.name}"
  end

  private

  def channel_params
    params.require(:channel).permit(:name)
  end
end
