require 'rails'
# INPUT = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)

parse_stack = -> (x) { x.split('').each_slice(4).map{ |x| x[1] } }
zip_stacks = -> (x) { x.first.zip(*x[1..]).map { |x| x.reverse.reject(&:blank?) } }
stack = -> () { INPUT[0..INPUT.index('')-2].map(&parse_stack).then(&zip_stacks) }

parse_inst = -> (x) { x.split(' ').each_slice(2).map{ |k,v| [k.to_sym, v.to_i] }.to_h }
inst = -> () {INPUT[INPUT.index('')+1..].map(&parse_inst)}

move = -> (s, i, f) { s[i[:to]-1] += f.(s[i[:from]-1].pop(i[:move])) }
arrange = -> (s, i, f) { i.empty? ? s : arrange.(s.tap { |s| move.(s, i.shift, f) }, i, f) }

puts arrange.(stack.(), inst.(), :reverse.to_proc).map(&:last).join
puts arrange.(stack.(), inst.(), :itself.to_proc).map(&:last).join
