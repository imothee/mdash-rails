require "test_helper"

class MdashMetricTest < ActiveSupport::TestCase
  setup do
    10.times do
      Example.create(status: :active, value: 3)
      Example.create(status: :active, value: 3, created_at: 1.day.ago)
      Example.create(status: :active, value: 3, created_at: 2.days.ago)
      Example.create(status: :active, value: 3, created_at: 1.week.ago)
      Example.create(status: :active, value: 3, created_at: 2.weeks.ago)
      Example.create(status: :active, value: 3, created_at: 1.month.ago)
      Example.create(status: :active, value: 3, created_at: 2.months.ago)
      Example.create(status: :active, value: 3, created_at: 1.year.ago)
      Example.create(status: :active, value: 3, created_at: 2.years.ago)
    end
    5.times do
      Example.create(status: :inactive, value: 5)
      Example.create(status: :inactive, value: 5, created_at: 1.day.ago)
      Example.create(status: :inactive, value: 5, created_at: 2.days.ago)
      Example.create(status: :inactive, value: 5, created_at: 1.week.ago)
      Example.create(status: :inactive, value: 5, created_at: 2.weeks.ago)
      Example.create(status: :inactive, value: 5, created_at: 1.month.ago)
      Example.create(status: :inactive, value: 5, created_at: 2.months.ago)
      Example.create(status: :inactive, value: 5, created_at: 1.year.ago)
      Example.create(status: :inactive, value: 5, created_at: 2.years.ago)
    end
  end

  test "should return a full count with just an aggregation" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count)
    assert_equal 135, metric.data
  end

  test "should return a full count for a day" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :day)
    assert_equal 15, metric.data
  end

  test "should return a full count for a week" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :week)
    assert_equal 45, metric.data
  end

  test "should return a full count for a month" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :month)
    assert_equal 75, metric.data
  end

  test "should return a full count for a year" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :year)
    assert_equal 105, metric.data
  end

  test "should return a full count for a day with a modifier" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :day, modifier: "active")
    assert_equal 10, metric.data
  end

  test "should return a full count for a day with a scope modifier" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :day, modifier: "not_active")
    assert_equal 5, metric.data
  end

  test "should handle multiple periods" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :day, periods: 2)
    expected = {}
    expected[Date.current.to_date] = 15
    expected[1.days.ago.to_date] = 15
    assert_equal expected, metric.data
  end

  test "should handle multiple periods with a modifier" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :count, period: :day, periods: 2, modifier: "active")
    expected = {}
    expected[Date.current.to_date] = 10
    expected[1.days.ago.to_date] = 10
    assert_equal expected, metric.data
  end

  test "should handle sum aggregation" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :sum, aggregation_column: :value, period: :day)
    assert_equal 55, metric.data
  end

  test "should handle sum aggregation with a modifier" do
    metric = Mdash::Metric.new(id: "example_total", model: "Example", aggregation: :sum, aggregation_column: :value, period: :day, modifier: "active")
    assert_equal 30, metric.data
  end
end