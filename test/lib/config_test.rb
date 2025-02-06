require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  test "should return nothing if the model doesn't exist" do
    config = Mdash::Configuration.new
    config.exported_metrics = {
      missing: {
        model: "Missing",
        metrics: {
          total: {
            aggregation: :count,
          }
        }
      }
    }
    assert config.metrics.empty?
  end

  test "should require a model to have metrics" do
    config = Mdash::Configuration.new
    config.exported_metrics = {
      users: {
        model: "Example",
        metrics: {
          total: {
            aggregation: :count,
          }
        }
      }
    }
    assert config.metrics.size == 1
  end

  test "should require a metric to be a hash" do
    config = Mdash::Configuration.new
    config.exported_metrics = {
      users: {
        model: "Account",
        metrics: {
          total: :count
        }
      }
    }
    assert config.metrics.empty?
  end

  test "should ignore duplicates" do
    config = Mdash::Configuration.new
    config.exported_metrics = {
      example_one: {
        model: "Example",
        metrics: {
          total: {
            aggregation: :count,
          },
        }
      },
      example: {
        model: "Example",
        metrics: {
          one_total: {
            aggregation: :count,
          }
        }
      }
    }
    assert config.metrics.size == 1
  end

  test "should build metrics" do
    config = Mdash::Configuration.new
    config.exported_metrics = {
      example_one: {
        model: "Example",
        metrics: {
          total: {
            aggregation: :count,
          },
        }
      },
      example: {
        model: "Example",
        metrics: {
          two_total: {
            aggregation: :count,
          }
        }
      }
    }
    assert config.metrics.size == 2
  end

  test "should require a metric to have a valid aggregation" do
    config = Mdash::Configuration.new
    config.exported_metrics = {
      users: {
        model: "Example",
        metrics: {
          total: :potato
        }
      }
    }
    assert config.metrics.empty?
  end
end