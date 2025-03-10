require "test_helper"

class ChannelTest < ActiveSupport::TestCase
  test "should not save channel without a name" do
    channel = Channel.new
    assert_not channel.save, "Saved the channel without a name"
  end

  test "should not save channel with duplicate name" do
    Channel.create(name: "Unique Channel")
    duplicate = Channel.new(name: "Unique Channel")
    assert_not duplicate.save, "Saved the channel with a duplicate name"
  end

  test "should have many messages" do
    channel = channels(:one)
    assert_respond_to channel, :messages
  end

  test "should have many users through channel_users" do
    channel = channels(:one)
    assert_respond_to channel, :users
  end

  test "should have many channel_users" do
    channel = channels(:one)
    assert_respond_to channel, :channel_users
  end

  test "should destroy associated channel_users when destroyed" do
    channel = Channel.create(name: "Temporary Channel")
    user = users(:one)
    ChannelUser.create(user: user, channel: channel)

    assert_difference "ChannelUser.count", -1 do
      channel.destroy
    end
  end
end
