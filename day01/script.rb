require 'rails'

l = []
n = 0

File.readlines("#{__dir__}/input.txt").each do |line|
  if line.blank?
    l << n
    n = 0
    next
  end

  n += line.to_i
end

puts l.sort.last
puts l.sort.last(3).sum
