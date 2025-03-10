require "test_helper"

class ChannelUserTest < ActiveSupport::TestCase
  test "should belong to user" do
    channel_user = channel_users(:one)
    assert_respond_to channel_user, :user
    assert_instance_of User, channel_user.user
  end

  test "should belong to channel" do
    channel_user = channel_users(:one)
    assert_respond_to channel_user, :channel
    assert_instance_of Channel, channel_user.channel
  end

  test "should create with valid attributes" do
    # Create a new user and channel to avoid uniqueness constraints
    user = User.create(email: "new_test@example.com", password: "password123")
    channel = Channel.create(name: "New Test Channel")

    channel_user = ChannelUser.new(user: user, channel: channel)
    assert channel_user.save, "Could not save valid channel_user"
  end

  test "should enforce unique user-channel combination" do
    # Create a fresh user and channel
    user = User.create(email: "unique_test@example.com", password: "password123")
    channel = Channel.create(name: "Unique Test Channel")

    # Add the user to the channel
    ChannelUser.create(user: user, channel: channel)

    # Try to create a duplicate
    duplicate = ChannelUser.new(user: user, channel: channel)

    # This should fail due to uniqueness validation
    assert_not duplicate.save, "Saved duplicate user-channel relationship"
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end

  test "should allow different users to join same channel" do
    # Create a new channel for this test
    channel = Channel.create(name: "Multiple Users Channel")

    # Create two users
    user1 = User.create(email: "user1_test@example.com", password: "password123")
    user2 = User.create(email: "user2_test@example.com", password: "password123")

    # Add user1 to the channel
    channel_user1 = ChannelUser.create(user: user1, channel: channel)
    assert channel_user1.persisted?, "Could not add first user to channel"

    # Now try to add user2 to the same channel
    channel_user2 = ChannelUser.new(user: user2, channel: channel)
    assert channel_user2.save, "Could not add different user to same channel"
  end

  test "should allow same user to join different channels" do
    # Create a user and two channels
    user = User.create(email: "multi_channel_user@example.com", password: "password123")
    channel1 = Channel.create(name: "Channel One")
    channel2 = Channel.create(name: "Channel Two")

    # Add user to channel1
    channel_user1 = ChannelUser.create(user: user, channel: channel1)
    assert channel_user1.persisted?, "Could not add user to first channel"

    # Now try to add the same user to channel2
    channel_user2 = ChannelUser.new(user: user, channel: channel2)
    assert channel_user2.save, "Could not add same user to different channel"
  end
end
