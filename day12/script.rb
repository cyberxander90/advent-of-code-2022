
INPUT1 = File.read("#{__dir__}/test-input.txt").split(/\r?\n/)
INPUT2 = File.read("#{__dir__}/input.txt").split(/\r?\n/)

DIRS = [[0, 1], [0, -1], [1, 0], [-1, 0]]
CHARS = ('a'..'z').to_a

def parse_graph(lines, reversed: false)
  vertexes = {}
  adjacent = {}
  start = nil
  ending = nil

  chars = lines.each_with_index.map do |line, i|
    line.split('').each_with_index.map { |char, j| [char, [i,j]] }
  end.flatten(1)

  chars.each do |(char, vertex)|
    if char == 'S'
      start = vertex
      char = 'a'
    end

    if char == 'E'
      ending = vertex
      char = 'z'
    end

    vertexes[vertex] = reversed ? (CHARS.length - CHARS.index(char) - 1) : CHARS.index(char)
  end

  chars.each do |(char, vertex)|
    adj = []
    adjacent[vertex] = adj

    DIRS.each do |(x,y)|
      next_vertex = [vertex[0]+x, vertex[1]+y]
      next unless vertexes[next_vertex]
      next unless (vertexes[next_vertex] - vertexes[vertex]) <= 1
      adj << next_vertex
    end
  end

  start, ending = [ending, start] if reversed
  [vertexes, adjacent, start, ending]
end

def dijkstra(vertexes, adjacent, start)
  dist = {}
  visited = {}
  queue = []

  vertexes.each do |v|
    dist[v] = Float::MAX
    visited[v] = false
    queue << v
  end

  dist[start] = 0

  while queue.any?
    v = queue.min_by { |v| dist[v] }
    visited[v] = true
    queue.delete(v)

    adjacent[v].each do |w|
      next if visited[w]

      new_dist = dist[v] + 1
      dist[w] = new_dist if new_dist < dist[w]
    end
  end

  dist
end

def part1(lines)
  vertexes, adjacent, start, ending = parse_graph(lines)
  dist = dijkstra(vertexes.keys, adjacent, start)
  dist[ending]
end

def part2(lines)
  vertexes, adjacent, start, ending = parse_graph(lines, reversed: true)
  dist = dijkstra(vertexes.keys, adjacent, start)

  min = Float::MAX
  vertexes.keys.each do |vertex|
    next if vertexes[vertex] != CHARS.length - 1
    min = [min, dist[vertex]].min
  end

  min
end

puts part1(INPUT1)
puts part1(INPUT2)

puts part2(INPUT1)
puts part2(INPUT2)
