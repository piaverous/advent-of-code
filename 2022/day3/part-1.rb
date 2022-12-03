#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 3 Part 1"
    puts "Starting #$title problem solving..."

    $lines = File.readlines("input.txt", chomp: true)
    puts "Read input file with #{$lines.length} lines"
}
END {
    puts "Finished solving #$title problem !"
}

$LOWERCASE_BYTE_OFFSET = 96 # "a".bytes = 97, but score for "a" is 1
$UPPERCASE_BYTE_OFFSET = 38 # "A".bytes = 65, but score for "A" is 27

def halves(str)
  [str[0, str.size/2], str[str.size/2..-1]]
end

score = 0
$lines.each do |line|
    first_half, second_half = halves(line)
    for char in first_half.bytes
        skip = false
        for c in second_half.bytes
            if char == c
                value = char < 97 ? char - $UPPERCASE_BYTE_OFFSET : char - $LOWERCASE_BYTE_OFFSET
                score += value
                skip = true
                break
            end
        end
        if skip
            break
        end
    end
end
puts score
