INPUT1 = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

DIR = { :< => [-1,0], :> => [1,0], d: [0, -1] }

def parse_dirs(lines)
  lines.first.split('').map(&:to_sym)
end

def next_cycle_item(list)
  list << list.shift
  list[-1]
end

def create_rock(rock_type, y)
  case rock_type
  when 1 then [[2,y], [3,y], [4,y], [5,y]]
  when 2 then [[3,y], [2,y+1], [3,y+1], [4,y+1], [3,y+2]]
  when 3 then [[2,y], [3,y], [4,y], [4,y+1], [4,y+2]]
  when 4 then [[2,y], [2,y+1], [2,y+2], [2,y+3]]
  when 5 then [[2,y], [3,y], [2,y+1], [3,y+1]]
  end
end

def can_move?(map, rock, dir, map_width)
  x,y = DIR[dir]
  rock.all? do |(x1,y1)|
    x2, y2 = [x1+x, y1+y]
    x2 >= 0 && x2 < map_width && y2 >= 0 && !map[[x2,y2]]
  end
end

def move(map, rock, dir, map_width)
  x,y = DIR[dir]
  rock.map { |(x1,y1)| [x1+x, y1+y] }
end

def set_rock(map, rock)
  rock.each { |(x,y)| map[[x,y]] = true }
end

def max_y_in_rock(rock)
  rock.map { |(x,y)| y }.max
end

def play(rocks:, dirs:, map_width:, rocks_count:)
  map = {}
  max_y, last_max_y = [0, 0]
  list = []

  while rocks_count > 0
    rock_type = next_cycle_item(rocks)
    rocks_count -= 1
    rock = create_rock(rock_type, map.empty? ? 3 : max_y + 4)

    while true
      dir = next_cycle_item(dirs)
      rock = move(map, rock, dir, map_width) if can_move?(map, rock, dir, map_width)

      break unless can_move?(map, rock, :d, map_width)
      rock = move(map, rock, :d, map_width)
    end

    set_rock(map, rock)
    max_y = [max_y, max_y_in_rock(rock)].max
    list << max_y - last_max_y
    last_max_y = max_y
  end

  [max_y + 1, list]
end

def part1(lines)
  play(rocks: (1..5).to_a, dirs: parse_dirs(lines), map_width: 7, rocks_count: 2022)[0]
end

##########################################################################################

def part2(lines)
  list = play(rocks: (1..5).to_a, dirs: parse_dirs(lines), map_width: 7, rocks_count: 100000)[1]
  pattern, i = find_cycle(list)
  sum_cycle_list(list, total: 1000000000000, cycle_start_at: i, cycle_length: pattern.length)
end

def find_cycle(original_list, min_cycle_length: 10, min_cycles_required: 20)
  list = original_list.reverse
  cycle_length = min_cycle_length

  while cycle_length < list.length
    pattern = list[0..cycle_length]
    i = index_of_sub_list(list, pattern, pattern.length)

    if i
      result_pattern = list[0...i]
      n = count_cycles(list, result_pattern)
      return [result_pattern.reverse, list.length - (result_pattern.length * n)] if n >= min_cycles_required
    end

    cycle_length += 1
  end

  nil
end

def count_cycles(list, pattern)
  count = 0
  j = 0
  while index_of_sub_list(list, pattern, j)
    count+=1
    j += pattern.length
  end
  count
end

def sum_cycle_list(list, total:, cycle_start_at:, cycle_length:)
  remaining = total - cycle_start_at
  total_cycles = remaining / cycle_length
  part_cycle = remaining % cycle_length

  result = 1
  result += list[0..(cycle_start_at-1)].sum
  result += list[cycle_start_at..(cycle_start_at+cycle_length-1)].sum * total_cycles
  result += list[cycle_start_at..(cycle_start_at+part_cycle-1)].sum
  result
end

def index_of_sub_list(list, sub_list, i = 0)
  while true
    i = index_of_item(list, sub_list.first, i)
    break unless i
    return i if list[i...i+sub_list.length] == sub_list
    i += 1
  end

  nil
end

def index_of_item(list, item, i = 0)
  while i < list.length
    return i if list[i] == item
    i+=1
  end
  nil
end

puts part1(INPUT1)
puts part1(INPUT2)

print part2(INPUT1)
print part2(INPUT2)
