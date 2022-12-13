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

def dijkstra(mat, start)
    vertex = [start]
    distances = Matrix[*Array.new(mat.row_count) { Array.new(mat.column_count) { 1000000000 } }]
    previous = Matrix[*Array.new(mat.row_count) { Array.new(mat.column_count) { -1 } }]

    distances[*start] = 0

    while vertex.length > 0
        v = vertex.shift

        neighbours = []
        (-1..1).each do |i|
            (-1..1).each do |j|
                if (i+j).abs != 1
                    next
                elsif v[0]+i < 0 || v[0]+i >= mat.row_count
                    next
                elsif v[1]+j < 0 || v[1]+j >= mat.column_count
                    next
                end
                neighbour = [v[0]+i, v[1]+j]
                if mat[*neighbour] <= mat[*v] + 1 
                    neighbours << neighbour
                    if previous[*neighbour] == -1
                        vertex << neighbour
                    end
                end
            end
        end


        neighbours.each do |n|
            dist = distances[*v] + 1
            if dist < distances[*n]
                distances[*n] = dist
                previous[*n] = v
            end
        end
    end
    return distances
end

$LOWERCASE_BYTE_OFFSET = 96 # "a".bytes = 97, but score for "a" is 1
class AdventSolver
    def initialize(title)
        @title = title
        puts "Starting #@title problem solving..."

        @lines = File.readlines("input.txt", chomp: true)
        puts "Read input file with #{@lines.length} lines"
    end

    def solve 
        m = []
        @lines.each do |line|
            m.push(line.bytes.map{ |b| b == 83 ? 0 : (b == 69 ? 100 : b-$LOWERCASE_BYTE_OFFSET) })
        end
        matrix = Matrix[*m]
        start_position, end_position = matrix.index(0), matrix.index(100)

        matrix[*start_position] = 1
        matrix[*end_position] = 26


        lowest_elevation_positions = []
        matrix.each_with_index do |e, i, j|
            if e == 1
                lowest_elevation_positions.push([i, j])
            end
        end

        min_steps = 1000000
        lowest_elevation_positions.each do |start|
            result = dijkstra(matrix, start)
            dist = result[*end_position]
            if dist < min_steps
                min_steps = dist
            end
        end
        return min_steps
    end
end


part = __FILE__.split(".")[0][-1]
day = File.basename(__dir__)[3..]

$solver = AdventSolver.new("AOC2022 Day #{day} Part #{part}")
if $args["bench"]
    Benchmark.bm do |x| 
        x.report("solving") { $solver.solve }
    end
else
    puts $solver.solve
end
