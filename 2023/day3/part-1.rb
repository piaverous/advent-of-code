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
        @height = @lines.length
        @width = @lines[0].length
        puts "Read input file with #{@height} lines"
    end

    def has_a_neighbour_symbol(positions)
        possible_symbols = ["-", "*", "&", "$", "@", "/", "#", "=", "%", "+"]
        x = positions[0][0]
        min_y = positions[0][1]
        max_y = positions[positions.length - 1][1]

        range_y_min = [0, min_y - 1].max
        range_y_max = [@width - 1, max_y + 1].min
        range_x_min = [0 , x - 1].max
        range_x_max = [@height - 1, x + 1].min

        for i in range_x_min..range_x_max
            for j in range_y_min..range_y_max
                if possible_symbols.include?(@lines[i][j])
                    return true
                end
            end
        end
        return false
    end

    def solve 
        sum = 0

        found_numbers = []

        for i in 0...@height
            current_number = ""
            num_positions = []
            line = @lines[i]
            for j in 0..@width
                ch = line[j]
                if !!(ch =~ /\d/) # Check if char is a digit
                    num_positions.append([i,j])
                    current_number += ch
                    was_number = true
                else
                    if was_number
                        found_numbers.append([current_number, num_positions.dup])
                        num_positions = []
                        current_number = ""
                    end
                    was_number = false
                end
            end
        end

        found_numbers.each do |item|
            num = item[0]
            positions = item[1]
            if has_a_neighbour_symbol(positions)
                sum += num.to_i
                puts num
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
