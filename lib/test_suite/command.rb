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

  end

end
