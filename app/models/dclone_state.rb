class DcloneState
  include Redis::Objects

  REGIONS = { 1 => 'Americas', 2 => 'Europe', 3 => 'Asia' }.freeze

  value :progress

  attr_reader :id

  def initialize(region_id)
    @id = region_id
  end

  def self.for_region(region_id)
    new(region_id)
  end

  def self.all_statuses
    REGIONS.map do |id, name|
      state = for_region(id)
      { region: name, progress: state.progress.value&.to_i || 'unknown' }
    end
  end
end
