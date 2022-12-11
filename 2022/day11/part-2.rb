#!/usr/bin/ruby -w
require 'benchmark'
require 'ruby-progressbar'

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
        monkeys = {}
        currentMonkey = -1
        @lines.each do |line|
            if line[0] == "M"
                currentMonkey += 1
            elsif line == ""
                next
            else
                instruction, term = line.split(":")
                instruction = instruction.strip || instruction
                i_words = instruction.split

                case i_words[0]
                when "Starting"
                    monkeys[currentMonkey] = {}
                    monkeys[currentMonkey]["touched"] = 0
                    monkeys[currentMonkey]["items"] = term.split(', ').map{ |i| i.to_i }
                when "Operation"
                    monkeys[currentMonkey]["operation"] = term.strip || term
                when "Test"
                    monkeys[currentMonkey]["test"] = term.split[-1].to_i
                when "If"
                    # Store in "true" or "false" key of monkey
                    monkeys[currentMonkey][i_words[1]] = term.split[-1].to_i
                end
            end
        end

        rounds = 10000
        progressbar = ProgressBar.create(:total => rounds)
        maxNeededNumber = monkeys.map { |_, m| m["test"]} .reduce(:*)
        rounds.times do
            progressbar.increment
            monkeys.each do |_, monkey|
                while monkey["items"].length > 0 do
                    monkey["touched"] += 1
                    new, old = 0, monkey["items"][0]
                    eval monkey["operation"]
                    
                    modulo = new % maxNeededNumber
                    new = modulo > 0 ? modulo : new
                    test_result =  (new % monkey["test"] == 0).to_s

                    next_monkey = monkey[test_result] # 2713310158

                    # Give the item to the next monkey
                    monkeys[next_monkey]["items"].push(new)

                    # Remove item we just looked at from monkey's items
                    monkey["items"] = monkey["items"][1..]
                end
            end
        end
        first, second = 0, 0
        monkeys.each do |_, monkey|
            if monkey["touched"] >= first
                first, second = monkey["touched"], first
            elsif monkey["touched"] >= second 
                second = monkey["touched"]
            end
        end
        return first * second
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
