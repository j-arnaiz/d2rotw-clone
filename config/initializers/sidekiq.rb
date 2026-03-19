require 'sidekiq/web'

# Sidekiq 8 checks Sec-Fetch-Site == "same-origin" for POST requests.
# Chrome only sends Sec-Fetch-* headers from "potentially trustworthy origins"
# (localhost, HTTPS). Plain HTTP over a local IP sends no Sec-Fetch-* headers
# at all, so we fall back to comparing the Origin header against the request host.
module Sidekiq
  class Web
    def safe_request?(env)
      return true if safe_methods?(env)

      sec_fetch_site = env["HTTP_SEC_FETCH_SITE"]
      if sec_fetch_site
        return %w[same-origin same-site].include?(sec_fetch_site)
      end

      # No Sec-Fetch-Site: plain HTTP over IP. Validate via Origin header.
      origin = env["HTTP_ORIGIN"]
      return true if origin.nil?
      expected = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
      origin == expected
    end
  end
end

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore,
  key: '_d2rotw_session',
  same_site: :lax,
  secure: false

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }

  Sidekiq::Cron::Job.load_from_hash(
    'dclone_check' => {
      'cron'  => '*/2 * * * *',
      'class' => 'DcloneCheckJob'
    }
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }
end
