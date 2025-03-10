require "application_system_test_case"

class ChannelsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @user.email = "user@example.com"
    @user.password = "password123"
    @user.save!

    @channel = channels(:one)
    @channel.name = "General"
    @channel.save!

    sign_in @user
  end

  test "visiting the index" do
    visit channels_path

    assert_selector "h1", text: "Channels"
    assert_selector "li", text: "General"
  end

  test "creating a new channel" do
    visit channels_path
    click_on "Create New Channel"

    # Use a unique channel name to avoid validation errors
    unique_name = "Test Channel #{Time.now.to_i}"
    fill_in "Name", with: unique_name

    # Use JavaScript to submit the form (workaround for Capybara issue)
    page.execute_script("document.querySelector('input[type=\"submit\"]').click()")

    # Verify we've been redirected to the channel page
    assert_selector "h1", text: unique_name
    assert_text "Channel created successfully"
  end

  test "joining a channel" do
    # Create a channel the user isn't a member of
    another_channel = Channel.create(name: "Another Channel")

    visit channels_path
    click_on "Another Channel"

    # We should be auto-joined and see the channel
    assert_selector "h1", text: "Another Channel"

    # Try sending a message to confirm we're joined
    fill_in "Type your message...", with: "I've joined this channel"
    click_on "Send"

    assert_selector ".message", text: "I've joined this channel"
  end

  test "leaving a channel" do
    visit channel_path(@channel)

    click_on "Leave Channel"

    # Should be redirected to channels index
    assert_selector "h1", text: "Channels"
  end
end
