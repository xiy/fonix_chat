require "application_system_test_case"

class MultiUserChatTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user1 = users(:one)
    @user1.email = "user1@example.com"
    @user1.password = "password123"
    @user1.save!

    @user2 = users(:two)
    @user2.email = "user2@example.com"
    @user2.password = "password123"
    @user2.save!

    @channel = channels(:one)
    @channel.name = "General"
    @channel.save!

    # Make sure both users are members of the channel
    ChannelUser.find_or_create_by(user: @user1, channel: @channel)
    ChannelUser.find_or_create_by(user: @user2, channel: @channel)
  end

  test "users can see each other's messages" do
    # Sign in as user1 and send a message
    sign_in @user1
    visit channel_path(@channel)

    fill_in "message_content", with: "Hello from User 1"
    click_on "Send"

    # Verify user1's message is visible
    assert_selector ".message", text: "Hello from User 1"

    # Sign out user1
    click_on "Back to Channels"
    find("a", text: "Logout").click

    # Sign in as user2
    sign_in @user2
    visit channel_path(@channel)

    # Verify user2 can see user1's message
    assert_selector ".message", text: "Hello from User 1"
    assert_selector ".message", text: "user1@example.com"

    # User2 sends a response
    fill_in "Type your message...", with: "Hello back from User 2"
    click_on "Send"

    # Verify user2's message is visible
    assert_selector ".message", text: "Hello back from User 2"
  end

  test "user can create and join a new channel" do
    # Sign in as user1 and create a channel
    sign_in @user1
    visit channels_path
    click_on "Create New Channel"

    channel_name = "Private Channel #{Time.now.to_i}"
    fill_in "Name", with: channel_name
    page.execute_script("document.querySelector('input[type=\"submit\"]').click()")

    # Verify channel was created and user1 is a member
    assert_selector "h1", text: channel_name

    # Send a message to the channel
    fill_in "Type your message...", with: "This is a private channel"
    click_on "Send"

    # Verify the message is visible
    assert_selector ".message", text: "This is a private channel"

    # Sign out user1
    click_on "Back to Channels"
    find("a", text: "Logout").click

    # Sign in as user2
    sign_in @user2
    visit channels_path

    # Join the new channel
    click_on channel_name

    # Verify user2 can see user1's message
    assert_selector ".message", text: "This is a private channel"

    # User2 sends a message
    fill_in "Type your message...", with: "I've joined your private channel"
    click_on "Send"

    # Verify user2's message is visible
    assert_selector ".message", text: "I've joined your private channel"
  end
end
