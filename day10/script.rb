INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)
# INPUT = File.read("#{__dir__}/test-input.txt").split(/\r?\n/)

def strengths
  result = 0
  register = 1
  cycle = 0
  cycles = (0..5).map { |i| 20 + (40*i) }

  INPUT.each do |l|
    break if cycles.empty?
    
    cycle += l == 'noop' ? 1 : 2
    result += cycles.shift * register if cycle >= cycles[0]
    register += l.split(' ')[1].to_i
  end

  result
end

puts strengths

def crt
  sprite = 0
  pixels = []
  pending = nil
  i = 0

  while INPUT.length > 0
    pixels << ((pixels.length % 40).between?(sprite, sprite + 2) ? '#' : '.')

    if pending
      sprite += pending
      pending = nil
      next
    end

    l = INPUT.shift
    next if l == 'noop'

    pending = l.split(' ')[1].to_i
  end

  pixels.each_slice(40).to_a.each { |l| puts l.join('') }
end

crt
