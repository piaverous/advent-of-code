#!/usr/bin/ruby -w
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

    def solve 
        @lines.each do |line|
            content = line.split
            if content[0] == "$"
                if content[1] == "cd"
                    if content[2] == ".."
                        $stack.pop()
                    else
                        $stack.push(content[2])

                        # Initialize directory object in map
                        path = $stack.join("/")
                        if !$directories[path]
                            $directories[path] = Directory.new(path)
                        end
                    end
                elsif content[1] == "ls"
                    next # Do nothing basically, this line contains no info
                end
            else
                path = $stack.join("/")
                if content[0] == "dir"
                    $directories[path].addChild(content[1])
                else
                    file_size = content[0].to_i
                    $directories[path].increment(file_size)
                end
            end
        end

        result = 0
        $directories.each do |key,dir|
            size = dir.computeSize
            if size <= 100000
                result += size
            end
        end

        return result
    end
end


$stack, $directories = [], {}
class Directory
    def initialize(path)
        @path = path
        @children = []
        @size = 0
        @totalSize = nil
    end

    def increment(size)
        @size += size
    end
    def addChild(child)
        @children.push(child)
    end

    def computeSize
        if @totalSize 
            return @totalSize
        else
            total = @size
            @children.each do |c|
                child = $directories[@path + "/" + c]
                total += child.computeSize
            end
            @totalSize = total
            return total
        end
    end
end

$solver = AdventSolver.new("AOC2022 Day 7 Part 1")
if $args["bench"]
    Benchmark.bm do |x| 
        x.report("solving") { $solver.solve }
    end
else
    puts $solver.solve
end
