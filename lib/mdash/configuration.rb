module Mdash
  class Configuration
    attr_accessor :secret
    attr_accessor :exported_metrics

    def metrics
      @metrics ||= exported_metrics.flat_map do |prefix, params|
        model = params[:model]
        params[:metrics].map do |k, metric_params|
          metric = Metric.new(id: "#{prefix}_#{k}", model: model, **metric_params)
          # Check if the metric is valid
          unless metric.valid?
            Rails.logger.warn("Invalid metric: #{metric.id}")
            return nil
          end
          metric
        end
      end
    end
  end
end