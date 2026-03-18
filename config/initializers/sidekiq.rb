Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }

  Sidekiq::Cron::Job.load_from_hash(
    'dclone_check' => {
      'cron'  => '* * * * *',
      'class' => 'DcloneCheckJob'
    }
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }
end
