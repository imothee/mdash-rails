module Mdash
  class Configuration
    attr_accessor :site_name
    attr_accessor :secret
    attr_accessor :cache_expiry
    attr_accessor :exported_metrics

    def initialize
      @cache_expiry = 5.minutes
    end

    def metrics
      @metrics ||= exported_metrics.each_with_object([]) do |(prefix, params), arr|
        # Check if the model exists, if not return
        next Rails.logger.warn("Invalid model: #{params[:model]}") unless params[:model].to_s.classify.safe_constantize

        params[:metrics].each do |k, metric_params|
          id = "#{prefix}_#{k}".to_sym
          # Check if the metric is a hash
          next Rails.logger.warn("Metric is not a hash: #{id}") unless metric_params.is_a?(Hash)
          # Check if metric id is unique
          next Rails.logger.warn("Duplicate metric: #{id}") if arr.any? { |m| m.id == id }

          # Create the metric
          metric = Metric.new(id:, model: params[:model], **metric_params)

          # Check if the metric is valid
          next Rails.logger.warn("Invalid metric: #{id}") unless metric.valid?

          arr << metric
        end
      end
    end
  end
end