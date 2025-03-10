require "application_system_test_case"

class MessagesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @user.email = "user@example.com"
    @user.password = "password123"
    @user.save!

    @channel = channels(:one)
    @channel.name = "General"
    @channel.save!

    @message = messages(:one)
    @message.content = "Hello, world!"
    @message.user = @user
    @message.channel = @channel
    @message.save!

    # Make sure the user is a member of the channel
    ChannelUser.find_or_create_by(user: @user, channel: @channel)

    sign_in @user
  end

  test "viewing messages in a channel" do
    visit channel_path(@channel)

    assert_selector ".message", text: "Hello, world!"
  end

  test "sending a message" do
    visit channel_path(@channel)

    # Fill in the message form and submit
    fill_in "Type your message...", with: "This is a test message"
    click_on "Send"

    # Check that the message appears in the chat
    assert_selector ".message", text: "This is a test message"
  end

  test "messages show the sender's email" do
    visit channel_path(@channel)

    assert_selector ".message", text: "user@example.com"
  end

  test "auto-joining a channel when visiting it" do
    # Create a new channel the user isn't a member of
    new_channel = Channel.create(name: "New Channel")

    # Visit the channel (should auto-join)
    visit channel_path(new_channel)

    # Send a message to verify we're joined
    fill_in "Type your message...", with: "I've joined automatically!"
    click_on "Send"

    # Check that the message appears
    assert_selector ".message", text: "I've joined automatically!"
  end
end
