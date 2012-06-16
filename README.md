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
┌────────────┬─────────┬─────────┐
│ Command    │ Runtime │ Status  │
├────────────┼─────────┼─────────┤
│ rspec      │ 13.923s │ success │
│ cucumber   │ 59.347s │ failed  │
│ javascript │ 31.003s │ success │
└────────────┴─────────┴─────────┘
```

This gem is extracted from a common pattern I found in my projects. You're
looking at an alpha release. The usage may change significantly in future
versions.

## Features

Currently, test_suite supports the following features:

* Define a set of commands
* Define if and when a command should fail the build
* Give a nice overview of all your commands

Planned features:

* Enforce cleanup commands to be run
* Provide a rake task
* Multiple outputs and formatters
* Stream output to a web server, via websockets, so you can observe your test
  suite from everywhere
* Run commands in parrallel

## Installation

Just install the gem:

```
gem install test_suite
```

Or add it to your Gemfile.

## Usage

Create a configuration file, called something like `script/test_suite.rb`:

``` ruby
TestSuite.configure do |config|

  config.command :migrate do |cmd|
    cmd.runs "bundle exec rake RAILS_ENV=test db:migrate:reset"
    cmd.fails_build_immediately!
  end

  config.command :rspec do |cmd|
    cmd.runs "bundle exec rspec --format progress --format html --out rspec.html"
  end

  config.command :cucumber do |cmd|
    cmd.runs "bundle exec cucumber --format html --out cucumber.html"
  end

  # Also use it to generate metrics
  config.command :brakeman do |cmd|
    cmd.never_fails_build!
  end

end
```

The `cmd.runs` is optional and only needed if the command is different from the
name.

By default, when a command fails, the next command will run. After all commands
have run, the build will fail.  This means that you can run multiple test
suites, and get a nice overview of which suite failed.

If a command is setting up stuff, you'll want to stop the build immediately if
it fails. For example, if the database couldn't be migrated, it has no use
running the test suites. You can mark these commands with
`cmd.fails_build_immediately!`.

If some process isn't important enough to break the build, you can mark them
with `cmd.never_fails_build!`.

You can run the test suite, by passing the filename to the test_run command.

```
test_run script/test_suite.rb
```

You can create multiple test suites, one for running on your CI server, one for
running locally. Simply create multiple files.

You can also split up your test suite, for more detailed results:

``` ruby
TestSuite.configure do |config|

  config.command "Unit Tests" do |cmd|
    cmd.runs "rspec spec/unit"
  end

  config.command "Integration Tests" do |cmd|
    cmd.runs "rspec spec/integration"
  end

end
```

I usually make a bash script to install the required gems. This has the benefit
that it can be run on your CI server more reliably.

``` bash
#!/bin/bash
set -e # let this script fail directly when errors occur
gem which bundler > /dev/null || gem install bundler --no-ri --no-rdoc
bundle check --no-color || bundle install --no-color
bundle exec test_suite script/test_suite.rb
```

Let me know if and how *you* use it!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
