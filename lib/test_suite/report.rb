# encoding: utf-8
module TestSuite
  class Report

    def self.call(commands)
      report = new(commands)
      report.call
      report
    end

    attr_reader :commands

    def initialize(commands)
      @commands = commands
    end

    def call
      report_lines << [ Column["Command"], Column["Runtime"], Column["Status"] ]
      commands.each do |command|
        report_lines << [ Column[command.name], Column[command.runtime, "s"], Column[command.status] ]
      end
      widths = report_lines.transpose.map { |line| line.max_by(&:size).size }
      header = report_lines.shift
      puts separator(widths, "┌", "┬", "┐")
      puts report_line(header, widths)
      puts separator(widths, "├", "┼", "┤")
      report_lines.each do |line|
        puts report_line(line, widths)
      end
      puts separator(widths, "└", "┴", "┘")
    end

    private

    def separator(widths, left, middle, right)
      left + widths.map { |width| "─" * (width + 2) }.join(middle) + right
    end

    def report_line(line, widths)
      "│ " + line.zip(widths).map { |(column, width)| column.aligned(width) }.join(" │ ") + " │"
    end

    def puts(*args)
      $stderr.puts(*args)
    end

    def report_lines
      @report_lines ||= []
    end

    class Column

      attr_reader :value, :suffix

      def self.[](value, suffix = "")
        new(value, suffix)
      end

      def initialize(value, suffix)
        @value, @suffix = value, suffix
      end

      def to_s
        string = case value
                 when Fixnum
                   value.to_s
                 when Numeric
                   "%.3f" % value
                 when NilClass
                   nil
                 else
                   value.to_s
                 end
        if string
          "#{string}#{suffix}"
        else
          ""
        end
      end

      def size
        to_s.size
      end

      def aligned(width)
        case value
        when Numeric
          to_s.rjust(width)
        else
          to_s.ljust(width)
        end
      end

    end

  end
end
