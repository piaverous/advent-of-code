#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 3 Part 2"
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

score, i = 0, 0
while i < $lines.length
    first, second, third = $lines[i], $lines[i+1], $lines[i+2]

    skip_f = false
    for f in first.bytes
        skip_s = false

        for s in second.bytes
            if f == s
                for t in third.bytes
                    if t == f
                        value = f < 97 ? f - $UPPERCASE_BYTE_OFFSET : f - $LOWERCASE_BYTE_OFFSET
                        score += value
                        skip_f, skip_s = true, true
                        break
                    end
                end
            end
            if skip_s
                break
            end
        end
        if skip_f
            break
        end
    end


    i += 3
end
puts score
