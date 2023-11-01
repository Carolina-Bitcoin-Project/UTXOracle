# UTXOracle.rb
Ruby implementation of https://utxo.live/oracle/.

(Original implementation by [SteveSimple](https://twitter.com/SteveSimple) & [DanielLHinton](https://twitter.com/DanielLHinton) who discovered and built the first offline bitcoin price oracle.)

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

#### Using a raw bitcoin node
```ruby
provider = Utxoracle::RawBitcoinNode.new("aUser", "aPassword", "127.0.0.1", 8332)
```

#### Using mempool.space node
```ruby
provider = Utxoracle::MempoolDotSpace.new
```

####
```ruby
oracle = Utxoracle::Oracle.new(provider)
oracle.price("2023-10-30")
34840
```

## Development

After checking out the repo, run `bundle i` to install dependencies.

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
