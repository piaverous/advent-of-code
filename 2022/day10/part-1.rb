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
        @lines.each do |line|
            instruction, value = line.split
            if instruction == "noop"
                cycle += 1
                if [20, 60, 100, 140, 180, 220].include?(cycle) 
                    registered_results[cycle] = [register, cycle*register]
                    result += cycle*register 
                end
            elsif instruction == "addx"
                cycle += 1
                if [20, 60, 100, 140, 180, 220].include?(cycle) 
                    registered_results[cycle] = [register, cycle*register]
                    result += cycle*register 
                end

                cycle += 1
                if [20, 60, 100, 140, 180, 220].include?(cycle) 
                    registered_results[cycle] = [register, cycle*register]
                    result += cycle*register 
                end            
                register += value.to_i
            end
        end
        return result
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
