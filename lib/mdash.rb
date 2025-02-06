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
      if @last_updated.nil? || @last_updated < config.cache_expiry.ago
        @stats = config.metrics.each_with_object({}) do |metric, stats|
          stats[metric.id] = metric.data
        end
        @last_updated = Time.now
      end
      @stats
    end

    def last_updated
      @last_updated
    end
  end
end

