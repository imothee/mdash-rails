require "mdash/version"
require "mdash/engine"
require "mdash/configuration"
require "groupdate"

module Mdash
  class Error < StandardError; end

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def stats
      # Check the last time stats were updated
      # If it's been more than 5 minutes, update the stats
      if @last_updated.nil? || @last_updated < 5.minutes.ago
        @stats = config.metrics.reduce({}) do |stats, metric|
          stats[metric.id] = metric.data
          stats
        end
        @last_updated = Time.now
      end
      @stats
    end
  end
end

