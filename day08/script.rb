GRID = File.read(__dir__+'/input.txt').split(/\r?\n/)
# GRID = File.read("#{__dir__}/test-input.txt").split(/\r?\n/)

N,M  = [GRID.length, GRID[0].length]

def indexes
  (0...N).to_a.product((0...M).to_a)
end

def adjacent(i, j)
  [(0...i).to_a.reverse, (i+1...N)].map { |l| l.to_a.map { |i2| GRID[i2][j] } } +
  [(0...j).to_a.reverse, (j+1...M)].map { |l| l.to_a.map { |j2| GRID[i][j2] } }
end

def visible?((i,j))
  return true if i == 0 || j == 0 || i == N-1 || j == M-1
  adjacent(i,j).any? { |l| l.all? { |h| GRID[i][j] > h } }
end

def score((i,j))
  adjacent(i,j).map do |l|
    count = l.take_while { |h| GRID[i][j] > h }.length
    count += 1 if count < l.length
    count
  end.flatten.reduce(&:*)
end

puts indexes.count(&method(:visible?))
puts indexes.map(&method(:score)).max