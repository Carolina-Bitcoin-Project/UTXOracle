[![Gem Version](https://badge.fury.io/rb/utxoracle.svg)](https://badge.fury.io/rb/utxoracle)

# Utxoracle
Offline price oracle for Bitcoin written in Ruby.

In September 2023 [SteveSimple](https://twitter.com/SteveSimple) & [DanielLHinton](https://twitter.com/DanielLHinton) [dropped](https://twitter.com/SteveSimple/status/1704864674431332503) https://utxo.live/oracle/, the first method to derive historical USD price of bitcoin based purely on UTXO set.

Needless to say, a lot of bitcoiners found this VERY cool. We're in a unique phase of history; transitioning from the Dollar Network to a Bitcoin Standard. Pulling out these patterns sparks joy.

The purpose of releasing Utxoracle as a Gem is multi-fold:
1. Make the tool available as a [Gem](https://rubygems.org/gems/utxoracle) to the Ruby community.
2. Provide a flexible API, where folks can extend this for other use cases (currencies, language, etc).
3. Provide a _modular_ provider model, so folks can pull data from mempool.space or other RPCs.


## Table of contents

- [Installation](#installation)
- [Usage](#usage)
  * [Requiring the gem](#requiring-the-gem)
  * [Fetching Price](#fetching-price)
- [Performance](#performance)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add utxoracle

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install utxoracle

## Usage

### Requiring the gem

All examples below assume that the gem has been required.

```ruby
require 'utxoracle'
```

### Fetching price

#### Using a specific bitcoin node

`bitcoin.conf` would look like:
```txt
server=1
rpcuser=aUser
rpcpassword=aPassword
```
```ruby
provider = Utxoracle::Node.new("aUser", "aPassword", "127.0.0.1", 8332)
oracle = Utxoracle::Oracle.new(provider, log = false)
oracle.price("2023-10-30")
34840
```

#### Using mempool.space node

```ruby
# Mempool will throttle you without an enterprise license
provider = Utxoracle::Mempool.new
oracle = Utxoracle::Oracle.new(provider, log = false)
oracle.price("2023-10-30")
34840
```

### Command line usage
```bash
$ ./bin/run aUser aPassword 127.0.0.1 8332 2023-10-10
Reading all blocks on 2023-10-12 00:00:00 -0400...
This will take a few minutes (~144 blocks)...
Height  Time(utc)       Completion %
811769  00:18:31        1.25
811770  00:22:48        1.53
811771  00:24:24        1.67
811772  00:33:32        2.29
811773  00:38:14        2.64
811774  01:06:40        4.58
811775  01:09:07        4.79
...
811931  23:41:09        98.68
811932  23:44:01        98.89
811933  23:48:40        99.17
blocks_on_this_day: 165
Price Estimate: $27,045
```

## Performance

Without optimization at the algorithmic/implementation level, UTXOracle.rb is able to compute prices for an entire month in ~10 minutes using native Ruby threads. 

Results on 3Ghz 6-Core Intel i5

For October 2023:
```ruby
$ ./bin/benchmark/run_range aUser aPassword 127.0.0.1 8332 2023-10-01 2023-11-01
[1] pry(main)> ret.sort
=> [[2023-10-01 00:00:00 -0400, 27364],
 [2023-10-02 00:00:00 -0400, 28345],
 [2023-10-03 00:00:00 -0400, 27696],
 [2023-10-04 00:00:00 -0400, 27712],
 [2023-10-05 00:00:00 -0400, 27725],
 [2023-10-06 00:00:00 -0400, 28021],
 [2023-10-07 00:00:00 -0400, 28311],
 [2023-10-08 00:00:00 -0400, 28308],
 [2023-10-09 00:00:00 -0400, 28000],
 [2023-10-10 00:00:00 -0400, 27708],
 [2023-10-11 00:00:00 -0400, 27373],
 [2023-10-12 00:00:00 -0400, 27045],
 [2023-10-13 00:00:00 -0400, 27058],
 [2023-10-14 00:00:00 -0400, 27077],
 [2023-10-15 00:00:00 -0400, 27093],
 [2023-10-16 00:00:00 -0400, 28357],
 [2023-10-17 00:00:00 -0400, 28664],
 [2023-10-18 00:00:00 -0400, 28658],
 [2023-10-19 00:00:00 -0400, 28690],
 [2023-10-20 00:00:00 -0400, 29704],
 [2023-10-21 00:00:00 -0400, 30034],
 [2023-10-22 00:00:00 -0400, 30333],
 [2023-10-23 00:00:00 -0400, 31069],
 [2023-10-24 00:00:00 -0400, 34468],
 [2023-10-25 00:00:00 -0400, 34858],
 [2023-10-26 00:00:00 -0400, 34484],
 [2023-10-27 00:00:00 -0400, 34114],
 [2023-10-28 00:00:00 -0400, 34438],
 [2023-10-29 00:00:00 -0400, 34841],
 [2023-10-30 00:00:00 -0400, 34840],
 [2023-10-31 00:00:00 -0400, 34829]]
[2] pry(main)> time
=> #<Benchmark::Tms:0x0000000110ddd310 @cstime=0.0, @cutime=0.0, @label="", @real=643.9174029999995, @stime=87.356026, @total=647.7391030000001, @utime=560.3830770000001>

# 643 seconds, or 10.7 minutes.
```


## Development

After checking out the repo, run `bundle install` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

The health and maintainability of the codebase is ensured through a set of
Rake tasks to test, lint and audit the gem for security vulnerabilities and documentation:

```
rake build                    # Build utxoracle-0.0.1.gem into the pkg directory
rake build:checksum           # Generate SHA512 checksum if utxoracle-0.0.1.gem into the checksums directory
rake clean                    # Remove any temporary products
rake clobber                  # Remove any generated files
rake install                  # Build and install utxoracle-0.0.1.gem into system gems
rake install:local            # Build and install utxoracle-0.0.1.gem into system gems without network access
rake release[remote]          # Create tag v0.0.1 and build and push utxoracle-0.0.1.gem to rubygems.org
rake rubocop                  # Run RuboCop
rake rubocop:autocorrect      # Autocorrect RuboCop offenses (only when it's safe)
rake rubocop:autocorrect_all  # Autocorrect RuboCop offenses (safe and unsafe)
rake spec                     # Run RSpec code examples
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Carolina-Bitcoin-Project/UTXOracle.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
