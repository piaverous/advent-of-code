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
        h_pos, t_pos = [0,0], [0,0]
        positions = {}

        @lines.each do |line|
            direction, num = line.split
            num.to_i.times do 
                case direction
                when "R"
                    h_pos[1] += 1
                    if mustMove(h_pos, t_pos)
                        t_pos = [h_pos[0], h_pos[1]-1]
                    end
                when "L"
                    h_pos[1] -= 1
                    if mustMove(h_pos, t_pos)
                        t_pos = [h_pos[0], h_pos[1]+1]
                    end
                when "U"
                    h_pos[0] -= 1
                    if mustMove(h_pos, t_pos)
                        t_pos = [h_pos[0]+1, h_pos[1]]
                    end
                when "D"
                    h_pos[0] += 1
                    if mustMove(h_pos, t_pos)
                        t_pos = [h_pos[0]-1, h_pos[1]]
                    end
                end
                positions[t_pos.join(';')] = true
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
