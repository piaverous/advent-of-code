#!/usr/bin/ruby -w

BEGIN {
    $title = "AOC2022 Day 5 Part 1"
    puts "Starting #$title problem solving..."

    $lines = File.readlines("input.txt", chomp: true)
    puts "Read input file with #{$lines.length} lines"
}
END {
    puts "Finished solving #$title problem !"
}


crates, moves = [], []
is_move = false
$lines.each do |line|
    if line.length == 0
        is_move = true
        next
    end

    if is_move
        moves.append(line)
    else
        crates.append(line)
    end
end
crates = crates.reverse

num_columns = crates[0].split(" ")[-1]
columns = []
num_columns.to_i.times do
    columns.append([])
end

crates[1..].each do |crate|
    chars = crate.chars.select.with_index{|_, x| x % 4 == 1}
    chars.each.with_index do |c, i|
        if c != " "
            columns[i].append(c)
        end
    end 
end 

mv = []
moves.each do |str|
    split = str.split
    number = split[1].to_i
    start_col = split[3].to_i - 1
    end_col = split[5].to_i - 1

    number.times do
        columns[end_col].append(columns[start_col].pop)
    end
end

columns.each do |col|
    print col[-1]
end
puts

