require_relative 'boot'
require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_job/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module D2rotwClone
  class Application < Rails::Application
    config.load_defaults 8.1

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.orm false
    end
  end
end
