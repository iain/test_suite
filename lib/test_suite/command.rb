require 'test_suite/command_failed'
require 'test_suite/executor'

module TestSuite

  class Command

    attr_reader :name

    def initialize(name, &block)
      @name = name
    end

    def runs(run)
      @run = run
    end

    def run
      @run || name.to_s
    end

    def important?
      @important
    end

    def fails_build_immediately!
      raise AmbiguousImportance if ignored?
      @important = true
    end

    def ignored?
      @ignored
    end

    def never_fails_build!
      raise AmbiguousImportance if important?
      @ignored = true
    end

    def always_run?
      @always_run
    end

    def always_run!
      @always_run = true
    end

    def run!(executor = Executor.new)
      measure do
        @exit_status = executor.run(run)
      end
      raise CommandFailed, self if broken?
    end

    def measure
      start = Time.now
      yield
    ensure
      @runtime = Time.now - start
    end

    def ok?
      ignored? || success?
    end

    def runtime
      @runtime
    end

    def status
      if never_ran?
        "didn't run"
      elsif success?
        "success"
      elsif ignored?
        "failed, but ignored"
      elsif broken?
        "broke the build"
      else
        "failed"
      end
    end

    def success?
      @exit_status == 0
    end

    def never_ran?
      @exit_status.nil?
    end

    def broken?
      !success? && important?
    end

  end

  class AmbiguousImportance < RuntimeError
  end

end
