# ActiveRecord::EnumeratedModel

ActiveRecord::EnumeratedModel is an ActiveRecord extensions that allows
you to create enumerated constants out of a model containing static
data.

Sometimes you have a model where values will not change. Consider the
following:

    class Role
      ADMIN = 1
      EDITOR = 2
      VIEWER = 3
    end

We'll often do something like this in order to easily check values in
our application.

    unless @current_user.has?(Role::ADMIN)
      # some admin stuff
    end

Keeping this out of ActiveRecord prevents us from doing any kind of
joining in the database and limits what +Role+ can do. Wouldn't be cool
if you could Role::ADMIN returned an ActiveRecord row?

    Role::ADMIN == #<Role name: "Admin">

This is what ActiveRecord::EnumeratedModel provides. Since we're dealing
with constants here, ActiveRecord::EnumeratedModel also makes your model
readonly.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-enumerated_model'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-enumerated_model

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
