
shape = -> (x) { { A: 1, X: 1, B: 2, Y: 2, C: 3, Z: 3 }[x.to_sym] }
won   = -> (x) { { 1 => 3, 2 => 1, 3 => 2 }[x] }
score = -> (a,b) { b + (a == b ? 3 : won.(b) == a ? 6 : 0) }
play  = -> (a,b) { b == 2 ? a : won.(b == 1 ? a : won.(a)) }

data = File.readlines(__dir__+'/input.txt').map{ |l| l.split(' ').map(&shape) }

puts data.map{ |(a,b)| score.(a, b) }.sum
puts data.map{ |(a,b)| score.(a, play.(a,b)) }.sum
