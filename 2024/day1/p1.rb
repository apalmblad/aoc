#!/usr/bin/env ruby
l1 = []
l2 = []
ARGF.each_line do |line|
  x, y = line.scan(/\d+/)
  l1 << x.to_i
  l2 << y.to_i
end
l1.sort!
sum = 0
l2.sort.each_with_index do |x, i|
  puts (l1[i] - x).abs
  sum += (l1[i] - x).abs
end
puts sum
