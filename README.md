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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/imothee/mdash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/imothee/policygen/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mdash project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/imothee/policygen/blob/main/CODE_OF_CONDUCT.md).
