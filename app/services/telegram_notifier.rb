module TelegramNotifier
  REGION_NAMES = { 1 => 'Americas', 2 => 'Europe', 3 => 'Asia' }.freeze

  def self.notify(region, new_progress, old_progress)
    token   = ENV['TELEGRAM_BOT_TOKEN']
    chat_id = ENV['TELEGRAM_CHAT_ID']

    return Rails.logger.warn('TelegramNotifier: missing token or chat_id') if token.nil? || chat_id.nil?

    text  = "🔥 D2 DClone Update!\n"
    text += "Region: #{REGION_NAMES[region] || region}\n"
    text += "Progress: #{old_progress || '?'} → #{new_progress}/6"
    text += "\n⚠️ WALKING NOW!" if new_progress == 6

    Faraday.post(
      "https://api.telegram.org/bot#{token}/sendMessage",
      { chat_id: chat_id, text: text }.to_json,
      'Content-Type' => 'application/json'
    )
  rescue => e
    Rails.logger.error "TelegramNotifier failed: #{e.message}"
  end
end
