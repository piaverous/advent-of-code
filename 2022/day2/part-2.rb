#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 2 Part 1"
    puts "Starting #$title problem solving..."

    $lines = File.readlines("input.txt", chomp: true)
    puts "Read input file with #{$lines.length} lines"
}
END {
    puts "Finished solving #$title problem !"
}


score = 0
$lines.each do |line|
    arr = line.split(" ")
    o_move, s_move = 0

    # Parse opponent move
    case arr[0]
    when "A"
        o_move = 1
    when "B"
        o_move = 2
    else
        o_move = 3
    end

    # Parse self move and compute score
    case arr[1]
    when "X" # Loss
        s_move = o_move - 1 == 0 ? 3 : o_move - 1
        score += s_move
    when "Y" # Draw
        s_move = o_move
        score += s_move + 3
    else # Win
        s_move = o_move + 1 == 4 ? 1 : o_move + 1
        score += s_move + 6
    end
end
puts score
