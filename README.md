# Fresh Objects

[![Gem Version](https://badge.fury.io/rb/fresh_objects.svg)](https://badge.fury.io/rb/fresh_objects) [![Build Status](https://travis-ci.org/bluemarblepayroll/fresh_objects.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/fresh_objects) [![Maintainability](https://api.codeclimate.com/v1/badges/157958522c93760a396c/maintainability)](https://codeclimate.com/github/bluemarblepayroll/fresh_objects/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/157958522c93760a396c/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/fresh_objects/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This library was built to support incoming data streams where you may or may not get the data in order.  Since the data coming in is guaranteed to be complete "per object", you only need to keep the latest copy of it and discard stale versions.  You can use this library to pass in all this data (in or out of order) and it will ensure only the freshest data is kept (stale copies are discarded.)

Note: persistence is outside of the scope of this library.  You can, however, use this library to access the "object id => timestamp" hash structure that is used for filtering and persist it.  Then, you can use it to re-hydrate a filter and pick up where you left off.

## Installation

To install through Rubygems:

````bash
gem install install fresh_objects
````

You can also add this to your Gemfile:

````bash
bundle add fresh_objects
````

## Examples

Say we have the following dataset:

````ruby
objects = [
  {
    id: 1,
    name: 'Batman'
    timestamp: '2019-01-02 12:00:00 UTC'
  },
  {
    id: 1,
    name: 'Superman'
    timestamp: '2019-01-02 12:00:01 UTC'
  },
  {
    id: 1,
    name: 'Ironman'
    timestamp: '2019-01-02 11:59:59 UTC'
  }
]
````

You could pass these objects into this library in order to resolve that the object you really want is the "Superman" object:

````ruby
filter = FreshObjects.filter(timestamp_key: :timestamp).add_each(objects)

filtered_objects = filter.objects
````

Now, filtered_objects should equal:

````ruby
[
  {
    id: 1,
    name: 'Superman'
    timestamp: '2019-01-02 12:00:01 UTC'
  }
]
````

Notes:

* You can change the object ID key by passing in the `id_key` into `FreshObjects#filter`.
* You can change the timestamp key by passing in the `timestamp_key` into `FreshObjects#filter`.
* You can change the resolver by passing in a custom `resolver` into `FreshObjects#filter`. Technically, a resolver can be anything with a #get ethod based on the [Objectable resolver#get method](https://github.com/bluemarblepayroll/objectable/blob/master/lib/objectable/resolver.rb).

### Saving a Filter

Ultimately what backs a filter is a hash with strings as keys and Time objects as values.  This can be accessed for persistence:

````ruby
lookup = filter.timestamps_by_id
````

Then, you can re-constitute a filter from this:

````ruby
filter = FreshObjects.filter(lookup: timestamps_by_id)
````

Notes:

* The lookup is just the timestamp cache, it does not contain the other options such as other Filter#new options.
* The next time you use a re-constituted filter, objects will be empty.  That means the `#objects` method is not cumulative across uses (per object instance.)  Remember, the goal of this library is the core filtering algorithm, not persistence.

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check fresh_objects.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/fresh_objects.git)
4. Navigate to the root folder (cd fresh_objects)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite and code-coverage tool, run:

````bash
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````bash
bundle exec guard
````

Also, do not forget to run Rubocop:

````bash
bundle exec rubocop
````

or run all three in one command:

````bash
bundle exec rake
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update `lib/fresh_objects/version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in this codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bluemarblepayroll/fresh_objects/blob/master/CODE_OF_CONDUCT.md).

## License

This project is MIT Licensed.
