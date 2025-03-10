require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "should not save message without content" do
    message = Message.new(user: users(:one), channel: channels(:one))
    assert_not message.save, "Saved the message without content"
  end

  test "should not save message without user" do
    message = Message.new(content: "Hello", channel: channels(:one))
    assert_not message.save, "Saved the message without a user"
  end

  test "should not save message without channel" do
    message = Message.new(content: "Hello", user: users(:one))
    assert_not message.save, "Saved the message without a channel"
  end

  test "should belong to user" do
    message = messages(:one)
    assert_respond_to message, :user
    assert_instance_of User, message.user
  end

  test "should belong to channel" do
    message = messages(:one)
    assert_respond_to message, :channel
    assert_instance_of Channel, message.channel
  end

  test "should create with valid attributes" do
    message = Message.new(
      content: "Test message",
      user: users(:one),
      channel: channels(:one)
    )
    assert message.save, "Could not save valid message"
  end

  # Note: Testing broadcast behavior would typically require more complex setup
  # with mocks or stubs for ActionCable broadcasting
end
