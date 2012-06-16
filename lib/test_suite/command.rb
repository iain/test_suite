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
      @important = true
    end

    def ignored?
      @ignored
    end

    def never_fails_build!
      @ignored = true
    end

    def run!
      PTY.spawn run do |read, write, pid|
        read.each_char do |char|
          print char
        end
        @exit_status = PTY.check(pid).to_i
      end
    rescue Errno::ENOENT => error
      $stderr.puts error
      @exit_status = 1
    ensure
      raise CommandFailed, self if important?
    end

    def ok?
      @exit_status == 0
    end

  end

end
