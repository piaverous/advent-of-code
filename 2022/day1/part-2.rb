#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 1 Part 2"
    puts "Starting #$title problem solving..."

    $lines = File.readlines("input.txt", chomp: true)
    puts "Read input file with #{$lines.length} lines"
}
END {
    puts "Finished solving #$title problem !"
}


sum = 0
first, second, third = 0, 0, 0
$lines.each_with_index do |line, i|
    if line == ""
        if sum >= first
            first, second, third = sum, first, second
        elsif sum >= second
            second, third = sum, second 
        elsif sum >= third 
            third = sum 
        end
        sum = 0
    else
        sum += line.to_i
    end
end
puts first + second + third

# Note : another solution is to put each sum into an array, and call array.sort.
# It is simpler in code but classical array sort has O(n*log(n)) complexity.
# This method with a couple more "if" statements has a O(n) complexity.
