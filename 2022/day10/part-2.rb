#!/usr/bin/ruby -w
require 'benchmark'
BEGIN {
    $args = {}

    ARGV.each do |arg|
        match = /--(?<key>.*)/.match(arg)
        $args[match[:key]] = true # e.g. args['bench'] = true
    end
}


class AdventSolver
    def initialize(title)
        @title = title
        puts "Starting #@title problem solving..."

        @lines = File.readlines("input.txt", chomp: true)
        puts "Read input file with #{@lines.length} lines"
    end

    def solve 
        cycle, register = 0, 1
        registered_results = {}
        result = 0
        render = ""
        @lines.each do |line|
            instruction, value = line.split
            if instruction == "noop"
                cycle += cycle == 40 ? -39 : 1
                render += (cycle <= register + 1 && cycle >= register - 1) ? "#" : "."
            elsif instruction == "addx"
                cycle += cycle == 40 ? -39 : 1
                render += (cycle <= register + 1 && cycle >= register - 1) ? "#" : "."

                cycle += cycle == 40 ? -39 : 1
                register += value.to_i
                render += (cycle <= register + 1 && cycle >= register - 1) ? "#" : "."

            end
        end
        puts render[0..39]
        puts render[40..79]
        puts render[80..119]
        puts render[120..159]
        puts render[160..199]
        puts render[200..239]
        return render.length
    end
end


part = __FILE__.split(".")[0][-1]
day = File.basename(__dir__)[3..]

$solver = AdventSolver.new("AOC2022 Day #{day} Part #{part}")
if $args["bench"]
    Benchmark.bm do |x| 
        x.report("solving") { $solver.solve }
    end
else
    puts $solver.solve
end
