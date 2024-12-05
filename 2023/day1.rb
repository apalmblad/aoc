#!/usr/bin/env ruby
sum = 0
# ARGF.each_line do |line|
#   digits = line.scan(/\d/)
#   sum += (digits.first + digits.last).to_i
# end
# puts sum

lookup = { "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9}
digits = 1.upto(9).to_a.map(&:to_s)

ARGF.each_line do |line|
  end_item = start_item = nil
  min = line.length + 1
  max = -1
  (lookup.keys + digits).each do |key|
    index = line.index(key)
    rindex = line.rindex(key)
    if index && index < min
      min = index
      start_item = key
    end
    if rindex && rindex > max
      max = line.rindex(key)
      end_item = key
    end
  end
  puts end_item.inspect
  puts start_item.inspect
  if lookup[end_item]
    end_item = lookup[end_item].to_s
  end
  if lookup[start_item]
    start_item = lookup[start_item].to_s
  end
  puts "got #{(start_item + end_item).to_i}"

  sum += (start_item + end_item).to_i
end
puts sum
