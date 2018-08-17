require 'sidekiq'

redis_url = ENV['REDIS_URL']



Sidekiq.default_worker_options = {
  'backtrace' => true,
  'retry' => false
}

schedule_file = "config/schedule.yml"
if File.exists?(schedule_file) #&& Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

unless Rails.env.test?
  Sidekiq::Logging.logger.level = Logger::DEBUG
  Rails.logger = Sidekiq::Logging.logger
end
