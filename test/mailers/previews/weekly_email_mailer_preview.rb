# Preview all emails at http://localhost:3000/rails/mailers/weekly_email_mailer
class WeeklyEmailMailerPreview < ActionMailer::Preview
  def weekly_summary
    user = User.first
    WeeklyEmailMailer.weekly_summary(user)
  end
end
