module Mdash
  class AnnounceController < ApplicationController
    def index
      available = Mdash.config.metrics.each_with_object({}) do |metric, hash|
        hash[metric.id] = {
          model: metric.model,
          aggregation: metric.aggregation,
          aggregation_column: metric.aggregation_column,
          period: metric.period,
          periods: metric.periods,
          modifier: metric.modifier
        }
      end

      render json: available.as_json
    end
  end
end