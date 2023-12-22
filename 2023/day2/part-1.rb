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
        reference = { "red" => 12, "green" => 13, "blue" => 14 }

        @lines.each do |line|
            id_and_sets = line.split(":")
            id = id_and_sets[0].split(" ")[1].to_i
            impossible = false
            
            sets = id_and_sets[1].split(";")
            sets.each do |set|
                num_and_color = set.split(",")
                num_and_color.each do |n_c|
                    picks = n_c.split(" ")
                    num = picks[0]
                    color = picks[1]
                    if num.to_i > reference[color]
                        impossible = true
                    end
                end
            end
            if impossible == false
                sum += id
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
