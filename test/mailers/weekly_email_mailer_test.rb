require "application_system_test_case"

class WeeklyEmailTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper
  include Devise::Test::IntegrationHelpers

  test "weekly email contains proper stats after chat activity" do
    # Clear previous emails
    ActionMailer::Base.deliveries.clear

    # Setup users and channel
    user1 = users(:one)
    user2 = users(:two)
    channel = channels(:one)

    # Sign in first user and send messages
    sign_in user1
    visit channel_path(channel)

    fill_in "Type your message...", with: "Hello from User 1"
    click_on "Send"

    # Sign out and sign in as second user
    click_on "Back to Channels"
    find("a", text: "Logout").click

    sign_in user2
    visit channel_path(channel)

    fill_in "Type your message...", with: "Response from User 2"
    click_on "Send"

    # Run the weekly email job
    perform_enqueued_jobs do
      WeeklyEmailJob.perform_now
    end

    # Check emails were sent and contain expected content
    assert_equal User.count, ActionMailer::Base.deliveries.size

    # Find user1's email
    user1_email = ActionMailer::Base.deliveries.find { |mail| mail.to.include?(user1.email) }
    assert_not_nil user1_email
    assert_equal "Weekly Summary", user1_email.subject
    assert_match "Messages sent:", user1_email.body.to_s
    assert_match "Messages received:", user1_email.body.to_s
    assert_match "messages have been exchanged in the last week", user1_email.body.to_s
  end
end
