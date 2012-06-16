module TestSuite
  class Executor

    def run(command)
      puts "\n\n\n========== #{command} ===========\n\n"
      system command
      $?.to_i
    end

  end
end
