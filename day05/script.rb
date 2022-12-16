require 'rails'

INPUT1 = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

def solution(lines)
  parse_stack = -> (x) { x.split('').each_slice(4).map{ |x| x[1] } }
  zip_stacks = -> (x) { x.first.zip(*x[1..]).map { |x| x.reverse.reject(&:blank?) } }
  stack = -> () { lines[0..lines.index('')-2].map(&parse_stack).then(&zip_stacks) }

  parse_inst = -> (x) { x.split(' ').each_slice(2).map{ |k,v| [k.to_sym, v.to_i] }.to_h }
  inst = -> () {lines[lines.index('')+1..].map(&parse_inst)}

  move = -> (s, i, f) { s[i[:to]-1] += f.(s[i[:from]-1].pop(i[:move])) }
  arrange = -> (s, i, f) { i.empty? ? s : arrange.(s.tap { |s| move.(s, i.shift, f) }, i, f) }

  [
    arrange.(stack.(), inst.(), :reverse.to_proc).map(&:last).join,
    arrange.(stack.(), inst.(), :itself.to_proc).map(&:last).join
  ]
end

puts solution(INPUT1)
puts solution(INPUT2)
