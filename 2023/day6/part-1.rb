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
        sum = 0
        
        @lines.each do |line|
            spl = line.split(":")
            id = spl[0][spl[0].length - 1].to_i
            inputs = spl[1].split("|")
            
            winning_numbers = inputs[0].split(" ")
            my_numbers = inputs[1].split(" ")

            pow = -1
            my_numbers.each do |num|
                if winning_numbers.include?(num)
                    pow += 1
                end
            end
            if pow >= 0
                sum += 2 ** pow 
            end
        end

        return sum
    end
end


part = __FILE__.split(".")[0][-1]
day = File.basename(__dir__)[3..]

$solver = AdventSolver.new("AOC2023 Day #{day} Part #{part}")
if $args["bench"]
    Benchmark.bm do |x| 
        x.report("solving") { $solver.solve }
    end
else
    puts $solver.solve
end
