# Schedule tasks
namespace :scheduler do
  desc "Send weekly email notifications"
  task send_weekly_emails: :environment do
    WeeklyEmailJob.perform_later # Enqueue the job asynchronously
  end
end
