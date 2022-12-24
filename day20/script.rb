INPUT1 = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)


def parse_numbers(lines)
  lines.each_with_index.map { |line, i| { index: i, value: line.to_i } }
end

def find_steps_to_right(list, move)
  steps = move.abs % list.length
  steps = list.length - steps if move < 0
  steps
end

def find_next_pos(list, pos, steps_to_right)
  pos += steps_to_right
  pos -= list.length if pos >= list.length
  pos
end

def find_number_to_the_left(numbers, index_to_find)
  i = index_to_find
  while numbers[i][:index] != index_to_find
    i -= 1
    i = numbers.length - 1 if i < 0
  end
  i
end

def mix(numbers)
  (0...numbers.length).each do |number_index_to_mix|
    pos = find_number_to_the_left(numbers, number_index_to_mix)
    number = numbers.delete_at(pos)
    steps_to_right = find_steps_to_right(numbers, number[:value])
    next_pos = find_next_pos(numbers, pos, steps_to_right)
    numbers.insert(next_pos, number)
    # puts "#{numbers.map {|x| x[:value]}}"
  end
  # puts "#{numbers.map {|x| x[:value]}}"
  numbers
end

def decrypt(numbers)
  index_of_number_0 = numbers.index { |x| x[:value] == 0 }
  [1000, 2000, 3000].map do |move|
    steps_to_right = find_steps_to_right(numbers, move)
    pos = find_next_pos(numbers, index_of_number_0, steps_to_right)
    numbers[pos][:value]
  end.sum
end

def part1(lines)
  numbers = mix parse_numbers(lines)
  decrypt(numbers)
end

def part2(lines)
  numbers = parse_numbers(lines)
  numbers.each { |number| number[:value] *= 811589153 }
  10.times { mix(numbers) }
  decrypt(numbers)
end

puts part1(INPUT1)
puts part1(INPUT2)

puts part2(INPUT1)
puts part2(INPUT2)
