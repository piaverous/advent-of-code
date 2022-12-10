#!/usr/bin/ruby -w
require 'benchmark'
BEGIN {
    $args = {}

    ARGV.each do |arg|
        match = /--(?<key>.*)/.match(arg)
        $args[match[:key]] = true # e.g. args['bench'] = true
    end
}

def mustMove(h_pos,t_pos)
    if (h_pos[0] - t_pos[0]).abs > 1
        return true
    end

    if (h_pos[1] - t_pos[1]).abs > 1
        return true 
    end
    return false
end


class AdventSolver
    def initialize(title)
        @title = title
        puts "Starting #@title problem solving..."

        @lines = File.readlines("input.txt", chomp: true)
        puts "Read input file with #{@lines.length} lines"
    end

    def solve 
        all_positions = (0..9).map{ |_| [0,0] }
        positions = {}

        @lines.each do |line|
            direction, num = line.split
            num.to_i.times do 
                case direction
                when "R"
                    all_positions[0][1] += 1
                when "L"
                    all_positions[0][1] -= 1
                when "U"
                    all_positions[0][0] += 1
                when "D"
                    all_positions[0][0] -= 1
                end

                (1..9).each do |i|
                    tail, head = all_positions[i], all_positions[i-1]
                    if mustMove(head, tail)
                        # If HEAD and TAIL are on the same column
                        if tail[0] == head[0]
                           if tail[1] - head[1] == 2 # TAIL is right of HEAD
                                tail[1] -= 1
                           elsif tail[1] - head[1] == -2 # TAIL is left of HEAD
                                tail[1] += 1
                           end
                        # If HEAD and TAIL are on the same line
                        elsif tail[1] == head[1]
                           if tail[0] - head[0] == 2 # TAIL is above HEAD
                                tail[0] -= 1
                           elsif tail[0] - head[0] == -2 # TAIL is below of HEAD
                                tail[0] += 1
                           end
                        else # HEAD and TAIL are diagonally separated AND must move
                           if tail[0] - head[0] == 2 # HEAD moved DOWN
                                if head[1] > tail[1] # HEAD is right of TAIL
                                    tail[0] -= 1
                                    tail[1] += 1
                                else # HEAD is left of TAIL
                                    tail[0] -= 1
                                    tail[1] -= 1
                                end
                           elsif tail[0] - head[0] == -2 # HEAD moved UP
                                if head[1] > tail[1] # HEAD is right of TAIL
                                    tail[0] += 1
                                    tail[1] += 1
                                else # HEAD is left of TAIL
                                    tail[0] += 1
                                    tail[1] -= 1
                                end
                           end
                           if tail[1] - head[1] == 2 # HEAD moved LEFT
                                if head[0] > tail[0] # HEAD is above TAIL
                                    tail[0] += 1
                                    tail[1] -= 1
                                else # HEAD is below TAIL
                                    tail[0] -= 1
                                    tail[1] -= 1
                                end
                           elsif tail[1] - head[1] == -2 # HEAD moved RIGHT
                                if head[0] > tail[0] # HEAD is above TAIL
                                    tail[0] += 1
                                    tail[1] += 1
                                else # HEAD is below TAIL
                                    tail[0] -= 1
                                    tail[1] += 1
                                end
                           end
                        end
                        all_positions[i] = tail
                    end
                end
                positions[all_positions[9].join(';')] = true
            end
        end
        return positions.keys.length
    end
end


part = __FILE__.split(".")[0][-1]
day = File.basename(__dir__)[-1]

$solver = AdventSolver.new("AOC2022 Day #{day} Part #{part}")
if $args["bench"]
    Benchmark.bm do |x| 
        x.report("solving") { $solver.solve }
    end
else
    puts $solver.solve
end
