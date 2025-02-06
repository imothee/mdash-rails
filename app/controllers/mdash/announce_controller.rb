module Mdash
  class AnnounceController < ApplicationController
    def index
      metrics = Mdash.config.metrics.map { |metric|
        {
          name: metric.id,
          model: metric.model,
          aggregation: metric.aggregation,
          aggregation_field: metric.aggregation_field,
          period: metric.period,
          periods: metric.periods,
          modifier: metric.modifier
        }
      }

      render json: {
        site_name: Mdash.config.site_name,
        metrics: metrics
      }.as_json
    end
  end
end