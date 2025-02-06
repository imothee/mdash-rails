module Mdash
  class Metric
    include ActiveModel::Model

    # Valid aggregations
    AGGREGATIONS = %i[sum average count].freeze
    # Valid periods
    PERIODS = %i[hour day week month year].freeze

    attr_reader :id, :model, :aggregation, :aggregation_field, :period, :periods, :modifier

    def self.all(configuration: nil)
      configuration ||= Mdash.config
      configuration.metrics
    end

    def self.find(id, configuration: nil)
      all(configuration:).find { |m| m.id == id.to_sym }.tap do |m|
        raise ActiveRecord::RecordNotFound unless m
      end
    end

    def initialize(id:, model:, aggregation:, aggregation_field: :id, period: nil, periods: nil, modifier: nil)
      @id = id.to_sym
      @model = model.to_sym
      @aggregation = aggregation.to_sym
      @aggregation_field = aggregation_field.to_sym
      @period = period&.to_sym
      @periods = periods
      @modifier = modifier
    end

    def valid?
      return false unless AGGREGATIONS.include?(@aggregation)
      return false unless PERIODS.include?(@period) if @period.present?

      return false if @periods.present? && !@periods.positive?

      true
    end

    def data
      clazz = @model.to_s.classify.constantize
      data = clazz.all
      data = data.send(@modifier) if @modifier.present?
      data = period_query(data) if @period.present? and @periods.nil?
      data = periods_query(data) if @period.present? and @periods.present? and @periods.positive?
      data = aggregation_query(data)
      data
    end

    private

    def period_query(query)
      case @period
      when :hour
        query.where(created_at: 1.hour.ago..Time.now)
      when :day
        query.where(created_at: 1.day.ago..Time.now)
      when :week
        query.where(created_at: 1.week.ago..Time.now)
      when :month
        query.where(created_at: 1.month.ago..Time.now)
      when :year
        query.where(created_at: 1.year.ago..Time.now)
      end
    end

    def periods_query(query)
      case @period
      when :hour
        query.where(created_at: @periods.hours.ago..Time.now).group_by_hour(:created_at)
      when :day
        query.where(created_at: @periods.days.ago..Time.now).group_by_day(:created_at)
      when :week
        query.where(created_at: @periods.weeks.ago..Time.now).group_by_week(:created_at)
      when :month
        query.where(created_at: @periods.months.ago..Time.now).group_by_month(:created_at)
      when :year
        query.where(created_at: @periods.years.ago..Time.now).group_by_year(:created_at)
      end
    end

    def aggregation_query(query)
      case @aggregation
      when :sum
        query.sum(@aggregation_field)
      when :avg
        query.average(@aggregation_field)
      when :count
        query.count
      end
    end
  end
end