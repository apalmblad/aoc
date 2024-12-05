#!/usr/bin/env ruby
sum = 0
is_counting = true
ARGF.each do |line|
  puts line
  line.scan(/(mul\((\d+),(\d+)\)|don't\(\)|do\(\))/).each do |pair|
    case pair[0]
    when "don't()"
      is_counting = false
    when "do()"
      is_counting = true
    else
      if is_counting
        sum += (pair[1].to_i * pair[2].to_i)
      end
    end
  end
end
puts sum
