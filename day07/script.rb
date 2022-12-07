require "ostruct"

# INPUT = File.read(__dir__+'/test-input.txt').split(/\r?\n/)
INPUT = File.read(__dir__+'/input.txt').split(/\r?\n/)

def new_dir(parent:)
  OpenStruct.new(parent: parent, dirs: {}, files: {}, size: 0)
end

def file_system(dir, lines)
  return if lines.empty?
  line = lines.shift

  if cd_to_dir = line.match(/^\$ cd (.+)$/)&.[](1)
    next_dir = cd_to_dir == '..' ? dir.parent : dir.dirs[cd_to_dir]
    return file_system(next_dir, lines)
  end

  if child_dir = line.match(/^dir (.+)$/)&.[](1)
    dir.dirs[child_dir] = new_dir(parent: dir)
  elsif (size, child_file = line.match(/^(\d+) (.+)$/)&.[](1..2))
    dir.files[child_file] = size.to_i
  end
  
  return file_system(dir, lines)
end

def root_dir
  root = new_dir(parent: nil)
  root.dirs['/'] = new_dir(parent: root)
  file_system(root, INPUT)
  root
end

def size(dir)
  dir.size = dir.files.values.sum + dir.dirs.values.map{ |d| size(d) }.sum
end

def each(dir, &b)
  dir.dirs.each do |k, v|
    b.({ type: :dir, name: k, size: v.size })
    each(v, &b)
  end

  dir.files.each do |k, v|
    b.({ type: :file, name: k, size: v })
  end
end

r = root_dir
size(r)

total = 0
each(r) do |i|
  if i[:type] == :dir && i[:size] <= 100000
    total += i[:size]
  end
end

puts total

free = 30000000 - (70000000 - r.dirs['/'].size)
best = r.dirs['/'].size
each(r) do |i|
  if i[:type] == :dir && i[:size] < best && i[:size] > free
    best = i[:size]
  end
end

puts best