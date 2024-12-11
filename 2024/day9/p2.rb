#!/usr/bin/env ruby
files = []
space = []
p = 0
line = ARGF.gets.chomp
#line = "2333133121414131402"
line.chars.each_with_index do |char, i|
  num = char.to_i
  if i % 2 == 0
    files << num.times.map { |i| p + i }
  else
    space << num.times.map { |i| p + i } 
  end
  p += num
end

(files.length - 1).downto(1) do |y|
  space.length.times do |x|
    if space[x].length >= files[y].length && files[y][0] > space[x][0]
      files[y] = space[x][..(files[y].length - 1)]
      space[x] = space[x][(files[y].length)..]
    end
  end
end


sum = 0
files.each_with_index do |sectors, file_id|
  sectors.each do |sector|
    sum += sector * file_id
  end
end
puts sum
