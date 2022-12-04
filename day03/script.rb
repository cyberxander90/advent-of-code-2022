
INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)
PRIORITY = ('a'..'z').to_a + ('A'..'Z').to_a

parse = -> (x) { x.split('')  }
items = -> (x) { x.each_slice(x.length / 2).to_a }
shared = -> (xs) { xs.reduce(&:&) }
priority = -> (x) { PRIORITY.index(x) + 1 }

puts INPUT.map(&(parse >> items >> shared >> :first.to_proc >> priority)).sum
puts INPUT.map(&parse).each_slice(3).map(&(shared >> :first.to_proc >> priority)).sum
