#!/usr/bin/env ruby

safe = 0

def safe_line?(numbers)
  is_ascending = numbers[1] - numbers[0] > 0
  diffs = numbers.each_with_index.each_with_object([]) do |(num, idx), memo|
    if idx > 0
      memo << (num - numbers[idx - 1])
    end
  end
  diffs.all? do |diff|
    diff.abs <= 3 && (is_ascending ? diff > 0 : diff < 0 )
  end
end
safe = 0
ARGF.each_line do |line|
  numbers = line.scan(/\d+/).map(&:to_i)
  is_safe = 0.upto(numbers.size - 1).any? do |idx|
    n = numbers.dup
    n.delete_at(idx)
    safe_line?(n)
  end
  safe += 1 if is_safe
end
puts safe
