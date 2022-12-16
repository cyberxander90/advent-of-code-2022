INPUT1 = File.read("#{__dir__}/test-input.txt").split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

def scan(lines)
  grid = {}
  min_left, max_right, max_down = nil

  lines.each do |line|
    coords = line.split('->').map { |coord| coord.split(',').map(&:to_i) }
    coords.each_cons(2) do |((i1,j1),(i2,j2))|
      grid[[i1,j1]] = true
      min_left = [min_left, i1, i2].compact.min
      max_right = [max_right, i1, i2].compact.max
      max_down = [max_down, j1, j2].compact.max
      
      ([j1,j2].min..[j1,j2].max).each { |j| grid[[i1,j]] = true } if i1 == i2
      ([i1,i2].min..[i1,i2].max).each { |i| grid[[i,j1]] = true } if j1 == j2
    end
  end

  [grid, min_left, max_right, max_down]
end

def simulation(lines, start)
  grid, min_left, max_right, max_down = scan(lines)
  path = [start]
  steps = 0

  while true
    i1, j1 = path[-1]
    available_pos = [[i1, j1+1], [i1-1, j1+1], [i1+1, j1+1]]
    i2, j2 = available_pos.find { |(i,j)| !grid[[i,j]] }

    if i2 == nil
      grid[[i1,j1]] = 1
      steps += 1
      path.pop
      next
    end

    break if (i2 < min_left || i2 > max_right || j2 > max_down)

    path << [i2,j2]
  end

  print_grid(grid, min_left, max_right, max_down, start, path)
  steps 
end

def simulation2(lines, start)
  grid, min_left, max_right, max_down = scan(lines)
  max_down += 2
  path = [start]
  steps = 0

  while path.any?
    i1, j1 = path[-1]
    min_left = [min_left, i1].compact.min
    max_right = [max_right, i1].compact.max

    available_pos = [[i1, j1+1], [i1-1, j1+1], [i1+1, j1+1]]
    i2, j2 = available_pos.find { |(i,j)| j < max_down && !grid[[i,j]] }

    if i2 == nil
      grid[[i1,j1]] = 1
      steps += 1
      path.pop
      next
    end

    path << [i2,j2]
  end

  print_grid(grid, min_left, max_right, max_down, start, path, with_ground: true)
  steps 
end

def print_grid(grid, min_left, max_right, max_down, start, path, with_ground: false)
  (0..max_down+1).each do |j|
    (min_left-1..max_right+1).each do |i|
      if with_ground && j == max_down
        print '#'
        next
      end

      if start == [i,j]
        print '+'
        next
      end

      if path.include?([i,j])
        print '~'
        next
      end

      v = grid[[i,j]]
      print v == 1 ? 'o' : v ? '#' : '.'
    end
    puts ''
  end
end

puts simulation(INPUT1, [500,0])
puts simulation(INPUT2, [500,0])

puts simulation2(INPUT1, [500,0])
puts simulation2(INPUT2, [500,0])