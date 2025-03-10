class WeeklyEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.find_each do |user|
      WeeklyEmailMailer.weekly_summary(user).deliver_later
    end
  end
end
