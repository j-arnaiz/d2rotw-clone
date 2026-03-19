class DcloneCheckJob
  include Sidekiq::Job

  def perform
    url = 'https://diablo2.io/dclone_api.php?' \
          "ladder=#{ENV.fetch('D2_LADDER', '1')}&" \
          "hc=#{ENV.fetch('D2_HC', '2')}&" \
          "ver=#{ENV.fetch('D2_VER', '2')}"

    response = Faraday.get(url)
    data = JSON.parse(response.body)

    data.each do |entry|
      region   = entry['region'].to_i
      progress = entry['progress'].to_i

      state    = DcloneState.for_region(region)
      last_val = state.progress.value&.to_i

      if last_val != progress
        state.progress.value = progress
        TelegramNotifier.notify(region, progress, last_val)
      end
    end
  rescue StandardError => e
    Rails.logger.error "DcloneCheckJob failed: #{e.message}"
  end
end
