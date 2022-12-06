INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)

packet = -> (d, l, i=3) { d[i-(l-1)..i].split('').uniq.length == l ? i+1 : packet.(d, l, i+1) }

puts packet.(INPUT.first, 4)
puts packet.(INPUT.first, 14)

def fast_packet(d, l)
  m = Hash.new 0

  (0..d.length).each do |i|
    c1 = d[i]
    m[c1] += 1

    if (j = i-l) >= 0
      c2 = d[j]
      m[c2] -= 1
      m.delete c2 if m[c2] <= 0
    end

    return i+1 if m.length == l
  end
end

puts fast_packet(INPUT.first, 4)
puts fast_packet(INPUT.first, 14)
