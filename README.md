# Travis Flags

Feature flags based on:

* global flags
* groups (e.g. `user=1,2,3`)
* percentage (modulo on a given id)

Allows specifying backend stores, such as Redis, Memcached, Postgresql etc.

#### Global flags

Flags can be enabled globally like so:

```ruby
flags = Flags.new
flags.enable(:feature)                      # enable globally
flags.enabled?(:feature)                    # enabled globally?
```

#### Flags per group

Flags can be enabled for specific groups by passing a type and id:

```ruby
flags = Flags.new
flags.enable(:feature, type: 'User', id: 1)   # enable for this user
flags.enabled?(:feature, type: 'User', id: 1) # enabled for this user?
```

#### Percentage

Percentages are calculated against the given id using modulo:

```ruby
flags = Flags.new
flags.enable(:feature, percent: 5)            # enable for 5%
flags.enabled?(:feature, id: 1)               # => true
flags.enabled?(:feature, id: 5)               # => false
```

#### Filtering input

Filters can be registered in order to turn domain objects into hashes for
convenience.

```ruby
flags = Flags.new(filter: :sequel)
flags.enable(:feature, user)                  # enable for this user
flags.enabled?(:feature, user)                # using the filter => true
flags.enabled?(:feature, type: 'User', id: 1) # not using the filter => true
```

Filters are included for [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord)
and [Sequel](https://github.com/jeremyevans/sequel).

Custom filters can be added by defining a class on `Travis::Flags::Filter` that
responds to:

* `apply?(object)` which returns `true` if the filter needs to be applied, and
* `apply(object)` which return a hash for the given object. The keys id and type must be defined on the returned hash.

See [travis/flags/filter.rb](https://github.com/travis-ci/travis-flags/tree/master/lib/travis/flags/filter.rb)
for examples.

#### Mapping domain objects

Domain specific object relations can be specified as custom data mappings:

```ruby
flags = Flags.new
flags.allow do |data|
  { type: data[:owner_type], id: data[:owner_id] } if data[:owner_id]
end

flags.enable(:feature, repo)          # enable for this user
flags.enabled?(:feature, repo.owner)  # => true
```

#### Keeping track of flags

Flags should be defined explicitely. Using undefined flags or flags that have
expired will log warnings.

```ruby
# do not log warnings until 2016-01-01
flags.define :feature, expires: '2016-01-01', purpose: 'try a new feature'

# never log any warnings
flags.define :feature, expires: :never, purpose: 'permanent flag'

# omitting an expiry date means the same
flags.define :feature, purpose: 'permanent flag'
```

#### In-memory caching

By default, reads from storage will be cached in memory for 5 seconds.
Intervals can be specified like so:

```ruby
# cache for 5 seconds (default)
flags = Flags.new(:redis)

# cache for 30 seconds
flags = Flags.new(:redis, cache: 30)

# do not cache in-memory:
flags = Flags.new(:redis, cache: 0)
```

Specifying a cache flush interval of `0` will disable in-memory caching.

#### Redundancy using multiple backends

For reading flags the first backend will be used as a primary store. Secondary
stores will be used in case of connection errors during reading. Changes to
flags will be stored to all backends:

```ruby
# Use Redis as a primary, and Postgresql as a secondary store.
flags = Flags.new(:redis, :db)

# Writes to all stores
flags.enable(:foo)
```

There's no write through for stores, so the same stores should be used for
reading and writing.
