INPUT1 = File.read("#{__dir__}/test-input.txt").split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

def parse_sensors(lines)
  reg_exp = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/
  lines.map { |line| line.match(reg_exp)[1..].map(&:to_i) }
end

def find_ranges(sensors, y)
  ranges = sensors.map do |(x1, y1, x2, y2)|
    len = (x2-x1).abs + (y2-y1).abs
    dist = (y1-y).abs
    count = len - dist

    count < 0 ? nil : (x1-count..x1+count)
  end.compact
end

def join_ranges(ranges, reversal: false)
  result = []

  xs = ranges.map { |range| [range.first, range.last] }.flatten.uniq.sort
  while xs.any?
    x = xs.shift
    result << x unless ranges.any? { |range| range.cover?(x-1) }
    result << x unless ranges.any? { |range| range.cover?(x+1) }
  end

  result.shift if reversal && result.any?
  result.pop if reversal && result.any?

  n,m = reversal ? [1,-1] : [0, 0]
  result.uniq.sort.each_slice(2).map { |(x,y)| (x+n..y+m) }
end

def count(ranges)
  ranges.map { |range| [range.last-range.first, 1].max }.sum
end

def collapse_ranges(ranges, min, max)
  ranges.map do |range|
    next nil if range.last < min
    next nil if range.first > max

    first = range.first
    first = min if first < min

    last = range.last
    last = max if last > max

    (first..last)
  end.compact
end

def part1(lines, y)
  sensors = parse_sensors(lines)
  ranges = find_ranges(sensors, y)
  ranges = join_ranges(ranges)
  count(ranges)
end

def part2(lines, max)
  sensors = parse_sensors(lines)

  (0..max).each do |y|
    puts y
    ranges = find_ranges(sensors, y)
    ranges = join_ranges(ranges, reversal: true)
    ranges = collapse_ranges(ranges, 0, max)
    if count(ranges) == 1
      x = ranges.first.first
      return x * 4000000 + y
    end
  end

  nil
end

puts part1(INPUT1, 10)
puts part1(INPUT2, 2000000)

puts part2(INPUT1, 20)
puts part2(INPUT2, 4000000)