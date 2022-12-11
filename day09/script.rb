INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)
# INPUT = File.read(__dir__+'/test-input.txt').split(/\r?\n/)

DIR = { L:[0,-1], R:[0,1], U:[-1,0], D:[1,0] }

def adjacent?((i,j), (i2,j2))
  [i-i2, j-j2].all? { |x| x.abs <= 1 }
end

def move((i,j), direction)
  DIR[direction.to_sym].then { |(x,y)| [i+x, j+y] }
end

def go_to((i,j), (i2,j2))
  [
    i>i2 ? :D : i<i2 ? :U : nil,
    j>j2 ? :R : j<j2 ? :L : nil
  ].compact
end

def visited_positions(length:)
  head, *knots = [[0,0]] * length
  visited = [head]
  
  INPUT.each do |line|
    direction, steps = line.split(' ')
    steps.to_i.times do |i|
      head = move(head, direction)

      knots.each_with_index do |knot, i|
        prev_knot = i == 0 ? head : knots[i-1]
        break if adjacent?(prev_knot, knot)
  
        go_to(prev_knot, knot).each { |dir| knot = move(knot, dir) }
        knots[i] = knot

        visited << knot if (i == knots.length - 1)
      end
    end
  end

  visited.uniq.count
end

puts visited_positions(length: 2)
puts visited_positions(length: 10)
