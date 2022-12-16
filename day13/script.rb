INPUT1 = File.read("#{__dir__}/test-input.txt").split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

def packets(lines)
  lines.map { |l| eval(l) }.compact.each_slice(2)
end

def ordered?(a, b)
  return a <=> b if [a,b].all? { |i| i.is_a?(Integer) }

  a = [a] if a.is_a?(Integer)
  b = [b] if b.is_a?(Integer)

  (0...[a.length, b.length].min).each do |i|
    r = ordered?(a[i], b[i])
    return r if r!= 0
  end

  a.length <=> b.length
end

def sum_packets(lines)
  packets(lines).each_with_index.map { |(a,b), i| ordered?(a, b) != 1 ? i+1 : 0 }.sum
end

def decoder_key(lines)
  k1 = [[2]]
  k2 = [[6]]
  all_packets = (packets(lines).to_a.flatten(1) + [k1, k2]).sort(&method(:ordered?))
  (all_packets.index(k1)+1) * (all_packets.index(k2)+1)
end

puts sum_packets(INPUT1)
puts sum_packets(INPUT2)

puts decoder_key(INPUT1)
puts decoder_key(INPUT2)