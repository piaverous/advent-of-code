#!/usr/bin/ruby -w
require 'matrix'
require 'benchmark'

BEGIN {
    $args = {}

    ARGV.each do |arg|
        match = /--(?<key>.*)/.match(arg)
        $args[match[:key]] = true # e.g. args['bench'] = true
    end
}


class AdventSolver
    def initialize(title)
        @title = title
        puts "Starting #@title problem solving..."

        @lines = File.readlines("input.txt", chomp: true)
        puts "Read input file with #{@lines.length} lines"
    end

    def parseMapAsMatrix
        mat = []
        @lines.each do |line|
            mat.append(line.chars.map { |c| c.to_i })
        end
        return Matrix[*mat]
    end

    def solve 
        visible = 0
        map = self.parseMapAsMatrix

        # Count all sides as visible
        visible += map.row_count * 2 + map.column_count * 2 - 4

        (1..map.row_count-2).each do |i|
            (1..map.column_count-2).each do |j|
                tree = map[i, j]

                sides_blocked = 0

                # Check if tree is visible from the LEFT
                map.row(i)[0..j-1].each do |t|
                    if t >= tree
                        sides_blocked += 1
                        break
                    end
                end
                if sides_blocked == 0
                    # puts tree.to_s + " is visible from LEFT (indexes " + i.to_s + "," + j.to_s + ")"
                    visible += 1
                    next
                end


                # Check if tree is visible from the RIGHT
                map.row(i)[j+1..].each do |t|
                    if t >= tree
                        sides_blocked += 1
                        break
                    end
                end
                if sides_blocked == 1
                    # puts tree.to_s + " is visible from RIGHT (indexes " + i.to_s + "," + j.to_s + ")"
                    visible += 1
                    next
                end

                # Check if tree is visible from the TOP
                map.column(j)[0..i-1].each do |t|
                    if t >= tree
                        sides_blocked += 1
                        break
                    end
                end
                if sides_blocked == 2
                    # puts tree.to_s + " is visible from TOP (indexes " + i.to_s + "," + j.to_s + ")"
                    visible += 1
                    next
                end

                # Check if tree is visible from the BOTTOM
                map.column(j)[i+1..].each do |t|
                    if t >= tree
                        sides_blocked += 1
                        break
                    end
                end
                if sides_blocked == 3
                    # puts tree.to_s + " is visible from BOTTOM (indexes " + i.to_s + "," + j.to_s + ")"
                    visible += 1
                    next
                end
            end
        end
        return visible
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
