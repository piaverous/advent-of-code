#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 4 Part 2"
    puts "Starting #$title problem solving..."

    $lines = File.readlines("input.txt", chomp: true)
    puts "Read input file with #{$lines.length} lines"
}
END {
    puts "Finished solving #$title problem !"
}

$LOWERCASE_BYTE_OFFSET = 96 # "a".bytes = 97, but score for "a" is 1
$UPPERCASE_BYTE_OFFSET = 38 # "A".bytes = 65, but score for "A" is 27

def parse_str_list_as_int(list)
  arr = []
  list.each do |elem|
    arr.append(elem.to_i)
  end
  return arr
end

score = 0
$lines.each do |line|
    
    first, second = line.split(",")
    first, second = first.split("-"), second.split("-")
    first, second = parse_str_list_as_int(first), parse_str_list_as_int(second)

    if (first[0] <= second[0] && second[0] <= first[1]) || (first[0] <= second[1] && second[1] <= first[1])
        score += 1
    elsif (second[0] <= first[0] && first[0] <= second[1]) || (second[0] <= first[1] && first[1] <= second[1])
        score += 1
    end
end
puts score
