
# INPUT = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)

parse = -> (x) { x.split(',').map{ |x| x.split('-').map(&:to_i) } }
in_range = -> ((a,b),(c,d)) { c>=a && d<=b }
overlap = -> ((a,b),(c,d)) { (c>=a && c<=b) || (d>=a && d<=b) }

puts INPUT.map(&parse).filter{ |(x,y)| in_range.(x,y) || in_range.(y,x) }.count
puts INPUT.map(&parse).filter{ |(x,y)| overlap.(x,y) || overlap.(y,x) }.count
