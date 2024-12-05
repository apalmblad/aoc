#!/usr/bin/env ruby
sum = 0
ARGF.each do |line|
  puts line
  line.scan(/mul\((\d+),(\d+)\)/).each do |pair|
    sum += (pair[0].to_i * pair[1].to_i)
  end
end
puts sum
