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

    def replace_num_chars(sentence)
        result = sentence.gsub('nine', '9')
        result = result.gsub('eight', '8')
        result = result.gsub('seven', '7')
        result = result.gsub('six', '6')
        result = result.gsub('five', '5')
        result = result.gsub('four', '4')
        result = result.gsub('three', '3')
        result = result.gsub('two', '2')
        result = result.gsub('one', '1')
        return result
    end

    def replace_num_chars_new(sentence)
        result = ""
        for i in 0...sentence.length
            ch = sentence[i].chr

            case ch
            when "o"
                if i+2 < sentence.length
                    if sentence[i..i+2] == "one"
                        result += "1"
                    end
                end
            when "t"
                if i+2 < sentence.length
                    if sentence[i..i+2] == "two"
                        result += "2"
                    end
                end
                if i+4 < sentence.length
                    if sentence[i..i+4] == "three"
                        result += "3"
                    end
                end
            when "f"
                if i+3 < sentence.length
                    if sentence[i..i+3] == "four"
                        result += "4"
                    end
                    if sentence[i..i+3] == "five"
                        result += "5"
                    end
                end
            when "s"
                if i+2 < sentence.length
                    if sentence[i..i+2] == "six"
                        result += "6"
                    end
                end
                if i+4 < sentence.length
                    if sentence[i..i+4] == "seven"
                        result += "7"
                    end
                end
            when "e"
                if i+4 < sentence.length
                    if sentence[i..i+4] == "eight"
                        result += "8"
                    end
                end
            when "n"
                if i+3 < sentence.length
                    if sentence[i..i+3] == "nine"
                        result += "9"
                    end
                end
            when "1", "2", "3", "4", "5", "6", "7", "8", "9"
                result += ch
            end
        end
        return result
    end

    def solve 
        sum = 0
        @lines.each do |line|
            nums = replace_num_chars_new(line)
            number = nums[0] + nums[nums.length - 1]
            sum += number.to_i
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
