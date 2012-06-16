require 'pty'
require 'test_suite/command_failed'

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

    def run!
      measure do
        PTY.spawn run do |read, write, pid|
          read.each_char do |char|
            print char
          end
          @exit_status = PTY.check(pid).to_i
        end
      end
    rescue Errno::ENOENT => error
      $stderr.puts error
      @exit_status = 1
    ensure
      raise CommandFailed, self if important?
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
      elsif important?
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

  end

  class AmbiguousImportance < RuntimeError
  end

end
