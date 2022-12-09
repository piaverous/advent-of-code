#!/usr/bin/ruby -w
require 'benchmark'
require 'matrix'
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
        map = self.parseMapAsMatrix

        max_score = 0

        (1..map.row_count-2).each do |i|
            (1..map.column_count-2).each do |j|
                tree = map[i, j]
                trees_visible = [0, 0, 0, 0]
                # Check how many trees are visible from the LEFT
                # Need to reverse in order to navigate from inside out
                map.row(i)[0..j-1].reverse.each do |t| 
                    trees_visible[0] += 1
                    if t >= tree
                        break
                    end
                end

                # Check how many trees are visible from the RIGHT
                map.row(i)[j+1..].each do |t|
                    trees_visible[1] += 1
                    if t >= tree
                        break
                    end
                end

                # Check how many trees are visible from the TOP
                # Need to reverse in order to navigate from inside out
                map.column(j)[0..i-1].reverse.each do |t|
                    trees_visible[2] += 1
                    if t >= tree
                        break
                    end
                end

                # Check how many trees are visible from the BOTTOM
                map.column(j)[i+1..].each do |t|
                    trees_visible[3] += 1
                    if t >= tree
                        break
                    end
                end
                score = trees_visible.reduce(:*)
                if score > max_score
                    max_score = score
                end
            end
        end
        return max_score
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
