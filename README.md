# TestSuite

A modern test suite contains many testing frameworks. It contains a suite of
unit tests, integration tests, end-to-end acceptance tests. If your application
is polyglot, you might have a tests for each language. Each suite can be
executed with a different command.

Regularly you'll need to run them all at once. Or you'll want to run some extra
commands, like setting up the database on your continuous integration server.

This gem will help you manage all your test suites and auxillary commands.

Here's an example of the test suite report you might get:

```
┌───────────────────────┬──────────┬────────┐
│ Command               │ Runtime  │ Status │
├───────────────────────┼──────────┼────────┤
│ Bundler               │  0.805 s │      0 │
│ Create TEST database  │  3.923 s │      0 │
│ Migrate TEST database │  9.347 s │      0 │
│ RSpec                 │ 50.003 s │      1 │
│ Brakeman              │  5.492 s │    768 │
│ Cane                  │  1.395 s │    256 │
└───────────────────────┴──────────┴────────┘
  The build failed because RSpec failed.
```

## (Planned) Features

For the first version:

* Define a set of commands
* Define if and when a command should fail the build
* Enforce cleanup commands to be run
* Give a nice overview of all your commands

For later versions:

* Multiple outputs and formatters
* Stream output to a web server, so you can observe your test suite from everywhere
* Run commands in parrallel

## Installation

Just install the gem:

```
gem install test_suite
```

Generate the test suite configuration:

```
test_suite generate
```

## Usage

The file generated contains configuration on which commands can be ran. Here is an example.

``` ruby
TestSuite.configure do |config|

  config.command :bundler do |cmd|
    cmd.run "bundle check || bundle install" # what should be run
    cmd.fails_build_immediately!
  end

  config.command :migrate do |cmd|
    cmd.run "bundle exec rake RAILS_ENV=test db:migrate:reset > /log/migrate.log"
    cmd.fails_build_immediately!
  end

  config.command :rspec do |cmd|
    cmd.run "bundle exec rspec --format progress --format html --out rspec.html"
  end

  config.command :cucumber do |cmd|
    cmd.run "bundle exec cucumber"
  end

  config.command :brakeman do |cmd|
    cmd.run "brakeman"
    cmd.ignore!
  end

end
```

By default, when a command fails, the next command will run. After all commands
have run, the build will fail.  This means that you can run multiple test
suites, and get a nice overview of which suite failed.

If a command is setting up stuff, you'll want to stop the build immediately if
it fails. For example, if the database couldn't be migrated, it has no use
running the test suites. You can mark these commands with
`cmd.fails_build_immediately!`

You can run the entire test suite:

```
test_suite go
```

For more options run:

```
test_suite --help
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
