require "sidekiq"
require "sidekiq-scheduler"
require "sidekiq-scheduler/web"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] }

  schedule_file = Rails.root.join("config/sidekiq.yml")

  if File.exist?(schedule_file)
    Sidekiq.schedule = YAML.load_file(schedule_file)["schedule"]
    Sidekiq::Scheduler.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] }
end
