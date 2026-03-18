class DashboardController < ApplicationController
  def index
    @statuses = DcloneState.all_statuses
    @api_params = {
      ladder: ENV.fetch('D2_LADDER', '1'),
      hc:     ENV.fetch('D2_HC', '2'),
      ver:    ENV.fetch('D2_VER', '2')
    }
  end
end
