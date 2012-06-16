module TestSuite
  class Configuration

    def commands
      @commands ||= []
    end

    def command(name)
      commands << name
    end

  end
end
