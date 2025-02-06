# Mdash
Mdash is the easiest, most secure and most efficient way to setup dashboards for your Rails apps.
Since we use client-side apps instead of bulky server-side embeds the overhead on your app and the surface area is kept to a minimum.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "mdash"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install mdash
```

#### Run the installer

To setup the Mdash config file in your rails project run

```bash
rails generate mdash:install
```

## Usage

Mount the Mdash engine in your routes file

```ruby
mount Mdash::Engine => "/mdash"
```

#### Configuration

There are three main sections to be configured to properly setup Mdash in your Rails app.

##### Site Name

This is the name of your site that will be displayed in the Mdash dashboard when setting up widgets.

```ruby
config.site_name = "Your Site Name"
```

##### Secret

This is the secret key that will be used to authenticate requests from Mdash to your app. 
In the future we plan to support authing against Mdash and storing the secret on our service but for now direct connections are the only way 

Requirements:
- Must be a string
- Must be at least 10 characters long but really use a longer one, please
- Ideally store this in your Rails credentials file or a secret manager

```ruby
config.secret = "a-really-long-secret-key"
```

##### Exported Metrics

This is where you define the metrics that you want to expose to Mdash.
Mdash will have predefined templates for common metrics but you can also define your own custom metrics.

A metric is defined by the following attributes:
- `model` - The name of the model that the metric is based on
- `metrics` - A hash of metrics that you want to expose
  - `aggregation` - The type of aggregation to perform on the model
  - `aggregation_field` - The field to aggregate on, defaults to `id`
  - `period` - The period over which to aggregate the metric
  - `periods` - The number of periods to aggregate over
  - `modifier` - A modifier to apply to the aggregation

Valid aggregations are:
- `:count` - Count the number of records
- `:sum` - Sum the values of a column
- `:average` - Average the values of a column

If you define an aggregation of sum or average you should also define the field to aggregate on with the `aggregation_field` attribute.
- String
- Default is `id`

Valid period values are:
- `nil` - No period, aggregate over all time
- `:hour` - Aggregate over an hour
- `:day` - Aggregate over a day
- `:week` - Aggregate over a week
- `:month` - Aggregate over a month
- `:year` - Aggregate over a year

If you define a period you can also define the number of periods to aggregate over with the `periods` attribute.
- Integer > 1
- Default is 1
- If periods is set then we will return an object of values even if periods is 1

If you define a modifier you can also define the modifier with the `modifier` attribute.
- String
- Default is nil
- Must be a method that exists on the model 

##### Example Config

Here's a real world example from https://timewith.xyz

```ruby
Mdash.configure do |config|
  config.site_name = "Timewith"
  config.secret = Rails.application.credentials.dig(:mdash, :secret)

  config.exported_metrics = {
    users: {
      model: "Account",
      metrics: {
        total: {
          aggregation: :count,
        },
        recent_signups: {
          aggregation: :count,
          period: :week,
        },
        weekly_signups: {
          aggregation: :count,
          period: :week,
          periods: 12,
        }
      }
    },
    profiles: {
      model: "Profile",
      metrics: {
        total: {
          aggregation: :count,
        }
      }
    },
    events: {
      model: "Event",
      metrics: {
        total: {
          aggregation: :count,
        }
      }
    },
    bookings: {
      model: "Booking",
      metrics: {
        total: {
          aggregation: :count,
        },
        recent: {
          aggregation: :count,
          period: :week,
        },
        weekly: {
          aggregation: :count,
          period: :week,
          periods: 12,
        },
        cancelled_total: {
          aggregation: :count,
          modifier: "cancelled",
        },
        cancelled_recent: {
          aggregation: :count,
          period: :week,
          modifier: "cancelled",
        },
      }
    }
  }
end
```

## Consuming

The simplest way to consume the metrics from Mdash is to use the Mdash App (coming soon).

If you want to consume the metrics in your own app you can use the Mdash API.

#### API

The Mdash API is a simple RESTful API that allows you to fetch the metrics that you have defined in your Rails app.

##### Authentication

To authenticate with the Mdash API you need to include the secret key that you defined in your Rails app as a header "X-Mdash-Token"

##### Announce

The announce endpoint contains a list of all the valid metrics that you have defined in your Rails app.

```http
GET /mdash/announce
```

```json
{
  "site_name": "Timewith",
  "metrics": [
    {
      "name": "users_total",
      "model": "Account",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": null,
      "periods": null,
      "modifier": null
    },
    {
      "name": "users_recent_signups",
      "model": "Account",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": "week",
      "periods": null,
      "modifier": null
    },
    {
      "name": "users_weekly_signups",
      "model": "Account",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": "week",
      "periods": 12,
      "modifier": null
    },
    {
      "name": "profiles_total",
      "model": "Profile",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": null,
      "periods": null,
      "modifier": null
    },
    {
      "name": "events_total",
      "model": "Event",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": null,
      "periods": null,
      "modifier": null
    },
    {
      "name": "bookings_total",
      "model": "Booking",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": null,
      "periods": null,
      "modifier": null
    },
    {
      "name": "bookings_recent",
      "model": "Booking",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": "week",
      "periods": null,
      "modifier": null
    },
    {
      "name": "bookings_weekly",
      "model": "Booking",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": "week",
      "periods": 12,
      "modifier": null
    },
    {
      "name": "bookings_cancelled_total",
      "model": "Booking",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": null,
      "periods": null,
      "modifier": "cancelled"
    },
    {
      "name": "bookings_cancelled_recent",
      "model": "Booking",
      "aggregation": "count",
      "aggregation_field": "id",
      "period": "week",
      "periods": null,
      "modifier": "cancelled"
    }
  ]
}
```

##### Stats

The stats endpoint allows you to fetch the values of the metrics that you have defined in your Rails app.
Stats contains the rollup values for each metric.
Last updated is the time that the stats were last updated (ie. if they're stale or cached)

```http
GET /mdash/stats
```

```json
{
  "stats": {
    "users_total": 1,
    "users_recent_signups": 0,
    "users_weekly_signups": {
      "2025-01-05": 1
    },
    "profiles_total": 2,
    "events_total": 2,
    "bookings_total": 4,
    "bookings_recent": 0,
    "bookings_weekly": {
      "2025-01-05": 4
    },
    "bookings_cancelled_total": 0,
    "bookings_cancelled_recent": 0
  },
  "last_updated": "2025-01-05T00:00:00Z"
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/imothee/mdash-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/imothee/policygen/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mdash project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/imothee/policygen/blob/main/CODE_OF_CONDUCT.md).
