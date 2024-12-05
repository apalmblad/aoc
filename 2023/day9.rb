#!/usr/bin/env ruby

def extrapolate(row)
  return 0 if row.all? { |x| x == 0 }
  return 0 if row.length == 1
  differences = row[0..-2].each_with_index.map do |x, i|
    row[i+1] - x
  end
  row.last + extrapolate(differences)
end

def back_extrapolate(row)
  return 0 if row.all? { |x| x == 0 }
  return 0 if row.length == 1
  differences = row[0..-2].each_with_index.map do |x, i|
    row[i+1] - x
  end
  row.first - back_extrapolate(differences)
end
sum = 0
ARGF.each_line do |line|
  sum += back_extrapolate(line.strip.split(/\s+/).map(&:to_i))
end
puts "RESULT"
puts sum
