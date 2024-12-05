#!/usr/bin/env ruby
l1 = []
l2 = []
counts = Hash.new { |a, b| a[b] = 0 }
ARGF.each_line do |line|
  x, y = line.scan(/\d+/)
  counts[y.to_i] += 1
  l1 << x.to_i
end

puts l1.sum { |x| x * counts[x].to_i }

