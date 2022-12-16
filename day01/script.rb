INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)

l = []
n = 0

INPUT.each do |line|
  if line.strip == ''
    l << n
    n = 0
    next
  end

  n += line.to_i
end

puts l.sort.last
puts l.sort.last(3).sum
