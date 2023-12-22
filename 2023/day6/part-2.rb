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
        cards = {}
        for id in 1..@lines.length # initialize card map
            cards[id] = 1
        end
        
        @lines.each do |line|
            spl = line.split(":")
            id = spl[0].split(" ")[1].to_i
            inputs = spl[1].split("|")
            
            winning_numbers = inputs[0].split(" ")
            my_numbers = inputs[1].split(" ")

            matches = 0
            my_numbers.each do |num|
                if winning_numbers.include?(num)
                    matches += 1
                end
            end
            for i in 1..matches
                cards[id+i] += cards[id]
            end
        end
        puts cards
        cards.each do |id, val|
            sum += val
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
