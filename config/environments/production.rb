Rails.application.configure do
  config.eager_load = true
  config.log_level = :info
  config.log_formatter = ::Logger::Formatter.new
  config.consider_all_requests_local = false

  # Allow any host (local IPs, localhost, etc.)
  config.hosts = [/.*/]

  # No SSL for local network
  config.force_ssl = false

  # Allow cookies over plain HTTP (no secure flag required)
  config.session_store :cookie_store,
    key: '_d2rotw_session',
    same_site: :lax,
    secure: false

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
