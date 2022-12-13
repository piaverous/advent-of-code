#!/usr/bin/ruby -w
require 'benchmark'
require 'io/console'

BEGIN {
    $args = {}

    ARGV.each do |arg|
        match = /--(?<key>.*)/.match(arg)
        $args[match[:key]] = true # e.g. args['bench'] = true
    end
}

def compareLists(first, second)
    puts "Starting compute for #{first.to_s} and #{second.to_s}"
    if first.length == 0 && second.length > 0
        puts "Left side ran out of items, so inputs are in the right order"
        return 1
    elsif second.length == 0 && first.length > 0
        puts "Right side ran out of items, so inputs are not in the right order"
        return -1
    end

    i = 0
    first.each do |f|
        if i >= second.length
            puts "Right side ran out of items, so inputs are not in the right order"
            return -1 # NOT right order
        end

        s = second[i]
        if f.class == Integer && s.class == Integer
            puts "Comparing #{f} and #{s}"
            if f < s 
                puts "Left side is smaller, so inputs are in the right order"
                return 1 # right order
            elsif f > s
                puts "Right side is smaller, so inputs are not in the right order"
                return -1 # NOT right order
            end
        elsif f.class == Array && s.class == Array
            val = compareLists(f, s)
            if val != 0
                return val
            end
        else
            if f.class == Integer && s.class == Array
                val = compareLists([f], s)
                if val != 0
                    return val
                end
            elsif f.class == Array && s.class == Integer
                val = compareLists(f, [s])
                if val != 0
                    return val
                end
            else
                puts "WHOT ??"
                puts "#{f.to_s} = #{f.class}"
                puts "#{s.to_s} = #{s.class}"
            end
        end
        i += 1
    end
    if i <= second.length - 1
        puts "Left side ran out of items, so inputs are in the right order"
        return 1
    end
    puts "Left side kind of ran out of items, so inputs are in the right order"
    return 0
end

class AdventSolver
    def initialize(title)
        @title = title
        puts "Starting #@title problem solving..."

        @lines = File.readlines("input.txt", chomp: true)
        puts "Read input file with #{@lines.length} lines"
    end

    def solve 
        first, second = [], []
        first_divider, second_divider = [[2]], [[6]]
        packets = [first_divider, second_divider]
        
        @lines.each_with_index do |line, i|
            puts ""
            case i%3
            when 0
                first = eval line
                packets << first
            when 1
                second = eval line
                packets << second
            end
        end
        sorted = packets.sort { |f, s| compareLists(f,s) == -1 ? 1 : -1  }

        first_div_index, second_div_index = 0, 0
        sorted.each_with_index do |p, i|
            if p.to_s == "[[2]]"
                first_div_index = i+1
            elsif p.to_s == "[[6]]"
                second_div_index = i+1
            end
        end
        return first_div_index * second_div_index


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
