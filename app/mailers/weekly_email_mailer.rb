class WeeklyEmailMailer < ApplicationMailer
  def weekly_summary(user)
    @user = user

    # Calculate some statistics for the user's activity
    start_date = 7.days.ago.beginning_of_day
    end_date = Time.current.end_of_day

    @sent_messages_count = user.messages.where(created_at: start_date..end_date).count
    @received_messages_count = Message.where(channel_id: user.channels.pluck(:id))
      .where.not(user_id: user.id)
      .where(created_at: start_date..end_date)
      .count

    @total_messages_count = @sent_messages_count + @received_messages_count

    # Get the user's last sent message date (not limited to the past week)
    @last_message_date = user.messages.maximum(:created_at)

    @total_received_since_last_sent = user.messages_since_last_sent.count

    mail(to: user.email, subject: "Weekly Summary")
  end
end
