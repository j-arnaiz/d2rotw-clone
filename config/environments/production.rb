Rails.application.configure do
  config.eager_load = true
  config.log_level = :info
  config.log_formatter = ::Logger::Formatter.new
  config.consider_all_requests_local = false

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
