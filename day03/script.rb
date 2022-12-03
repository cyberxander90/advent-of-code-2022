
INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)
PRIORITY = ('a'..'z').to_a + ('A'..'Z').to_a

parse = -> (x) { x.split('')  }
items = -> (x) { x.each_slice(x.length / 2).to_a }
shared = -> (xs) { xs.reduce(&:&) }
first = -> (x) { x.first }
priority = -> (x) { PRIORITY.index(x) + 1 }

map = -> (x, *f) { f.reduce(x) { |x, fi| x.map(&fi) } }

puts map.(INPUT, parse, items, shared, first, priority).sum
puts map.(map.(INPUT, parse).each_slice(3), shared, first, priority).sum
