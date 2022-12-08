#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 6 Part 2"
    puts "Starting #$title problem solving..."

    $lines = File.readlines("input.txt", chomp: true)
    puts "Read input file with #{$lines.length} lines"
}
END {
    puts "Finished solving #$title problem !"
}


input = $lines[0]
i = 0
found = false
distinct_character_amount = 14
while !found && i < input.length - distinct_character_amount
    window = input[i..i+distinct_character_amount-1]
    equals = false
    window.chars.each.with_index do |c, n|
        window[n+1..].chars.each do |ch|
            if c == ch
                equals = true
                break
            end
        end
        if equals 
            break
        end
    end
    if equals == false
        found = true
    end
    i += 1
end
puts i + distinct_character_amount - 1
