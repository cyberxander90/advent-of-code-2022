INPUT1 = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

DIRS = [
  [0,0,1], [0,0,-1],
  [0,1,0], [0,-1,0],
  [1,0,0], [-1,0,0],
];

def parse_cubes(lines)
  lines.map { |line| line.split(',').map(&:to_i) }
end

def adjacent((x,y,z))
  DIRS.map { |x1,y1,z1| [x+x1, y+y1, z+z1] }
end

def count_free_faces(cubes)
  cubes_map = cubes.map { |cube| [cube.to_s, true] }.to_h
  cubes.map do |cube|
    adjacent(cube).reject { |adj| cubes_map.key?(adj.to_s) }.length
  end.sum
end

def part1(lines)
  count_free_faces parse_cubes(lines)
end

def find_borders(cubes)
  min = [Float::MAX] * 3
  max = [Float::MIN] * 3

  cubes.each do |cube|
    (0...3).each do |i|
      min[i] = [min[i], cube[i]].min
      max[i] = [max[i], cube[i]].max
    end
  end

  [min, max]
end

def reach_borders?(cube, min, max, cubes_map, store, visited)
  cube_str = cube.to_s

  return store[cube_str] if store.key?(cube_str)
  return false if cubes_map.key?(cube_str)
  return true if (0...3).any? { |i| cube[i] <= min[i] || cube[i] >= max[i] }

  visited[cube_str] = true
  adjacent(cube).each do |adj_cube|
    next if visited.key?(adj_cube.to_s)
    return true if reach_borders?(adj_cube, min, max, cubes_map, store, visited)
  end

  return false
end

def count_external_free_faces(cubes)
  cubes_map = cubes.map { |cube| [cube.to_s, true] }.to_h
  min, max = find_borders(cubes)
  store = {}

  cubes.map do |cube|
    adjacent(cube).select do |adj_cube|
      visited = {}
      reach_border = reach_borders?(adj_cube, min, max, cubes_map, store, visited)
      visited.keys.each { |visited_cube| store[visited_cube] = reach_border }
      reach_border
    end.length
  end.sum
end

def part2(lines)
  count_external_free_faces parse_cubes(lines)
end

puts part1(INPUT1)
puts part1(INPUT2)

puts part2(INPUT1)
puts part2(INPUT2)