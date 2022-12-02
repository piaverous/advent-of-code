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

    # Parse self move
    case arr[1]
    when "X"
        s_move = 1
    when "Y"
        s_move = 2
    else
        s_move = 3
    end
    
    score += s_move    
    if o_move == s_move
        score += 3
    else 
        s_move = s_move == 1 ? 4 : s_move       # Compensate 1 wins vs 3 by considering 1 worth 4 in terms of "strength"
        score += s_move == o_move + 1 ? 6 : 0   # if self move is exactly opponent move +1, it means we win
    end 
end
puts score

