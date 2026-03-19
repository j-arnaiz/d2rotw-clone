require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore,
  key: '_d2rotw_session',
  same_site: :lax,
  secure: false

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }

  Sidekiq::Cron::Job.load_from_hash(
    'dclone_check' => {
      'cron'  => '*/5 * * * *',
      'class' => 'DcloneCheckJob'
    }
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }
end
