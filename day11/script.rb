INPUT1 = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

def parse_monkeys(lines)
  monkeys = []
  divisible_by = []
  i = 0

  while i < lines.length
    monkey = {
      items: lines[i+1].split(':')[1].split(',').map(&:to_i),
      operation: eval("-> (old) { #{lines[i+2].split('=')[1]} }"),
      divisible_by: lines[i+3].split('by')[1].to_i,
      if_true: lines[i+4].split('monkey')[1].to_i,
      if_false: lines[i+5].split('monkey')[1].to_i,
      inspected: 0,
    }

    monkeys << monkey
    divisible_by << monkey[:divisible_by]
    i+=7
  end

  [monkeys, divisible_by.reduce(&:*)]
end

def throw_items(monkeys, divided_by, divisible_by_all)
  monkeys.each do |monkey|
    monkey[:inspected] += monkey[:items].length
    while monkey[:items].length > 0
      item = monkey[:items].shift
      item = monkey[:operation][item]
      item = item / divided_by
      item = item % divisible_by_all

      is_divisible = item % monkey[:divisible_by] == 0
      throw_to = monkey[is_divisible ? :if_true : :if_false]

      monkeys[throw_to][:items] << item
    end
  end
end

def inspected_items(lines, rounds:, divided_by:)
  monkeys, divided_by_all = parse_monkeys(lines)
  rounds.times { throw_items(monkeys, divided_by, divided_by_all) }
  monkeys.map { |monkey| monkey[:inspected] }.sort.reverse[0..1].reduce(&:*)
end

puts inspected_items(INPUT1, rounds: 20, divided_by: 3)
puts inspected_items(INPUT2, rounds: 20, divided_by: 3)

puts inspected_items(INPUT1, rounds: 10000, divided_by: 1)
puts inspected_items(INPUT2, rounds: 10000, divided_by: 1)
  