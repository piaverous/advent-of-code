#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 1 Part 1"
    puts "Starting #$title problem solving..."

    $lines = File.readlines("input.txt", chomp: true)
    puts "Read input file with #{$lines.length} lines"
}
END {
    puts "Finished solving #$title problem !"
}


sum, max = 0, 0
$lines.each do |line|
    if line == ""
        max = sum > max ? sum : max
        sum = 0
    else
        sum += line.to_i
    end
end
puts max
