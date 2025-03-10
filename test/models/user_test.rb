require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should have many messages" do
    user = users(:one)
    assert_respond_to user, :messages
  end

  test "should have many channels through channel_users" do
    user = users(:one)
    assert_respond_to user, :channels
  end

  test "should require email" do
    user = User.new(password: "password123")
    assert_not user.save, "Saved the user without an email"
  end

  test "should require unique email" do
    User.create(email: "test@example.com", password: "password123")
    duplicate = User.new(email: "test@example.com", password: "password123")
    assert_not duplicate.save, "Saved the user with a duplicate email"
  end

  # test "the truth" do
  #   assert true
  # end
end
