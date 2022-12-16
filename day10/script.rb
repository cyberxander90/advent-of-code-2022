INPUT1 = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT2 = File.read(__dir__+'/input.txt').split(/\r?\n/)

def strengths(lines)
  result = 0
  register = 1
  cycle = 0
  cycles = (0..5).map { |i| 20 + (40*i) }

  lines.each do |line|
    break if cycles.empty?

    cycle += line == 'noop' ? 1 : 2
    result += cycles.shift * register if cycle >= cycles[0]
    register += line.split(' ')[1].to_i
  end

  result
end

def crt(lines)
  sprite = 0
  pixels = []
  pending = nil
  i = 0

  while lines.length > 0
    pixels << ((pixels.length % 40).between?(sprite, sprite + 2) ? '#' : '.')

    if pending
      sprite += pending
      pending = nil
      next
    end

    line = lines.shift
    next if line == 'noop'

    pending = line.split(' ')[1].to_i
  end

  pixels.each_slice(40).to_a.each { |list| puts list.join('') }
end

puts strengths(INPUT1)
puts strengths(INPUT2)

crt(INPUT1)
crt(INPUT2)
