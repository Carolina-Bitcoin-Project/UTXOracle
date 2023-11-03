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
oracle = Utxoracle::Oracle.new(provider, log = true)
oracle.price("2023-10-30")
34840
```

#### Using mempool.space node

```ruby
# Mempool will probably throttle you without an enterprise license
provider = Utxoracle::Mempool.new
oracle = Utxoracle::Oracle.new(provider, log = true)
oracle.price("2023-10-30")
34840
```

### Command line usage
```bash
$ ./bin/run <username> <password> 127.0.0.1 8332 2023-10-10
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
