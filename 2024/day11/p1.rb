#!/usr/bin/env ruby --jit

line = ARGF.gets
stones = line.chomp.split(" ").map(&:to_i)
@memo = {}
def tick(stone, times)
  return 1 if times == 0
  #@memo[stone] ||= {}
  #@memo[stone][times] ||= begin
    puts "Calculating #{stone} #{times}"
    if stone == 0
      tick(1, times - 1)
    elsif stone.to_s.length.even?
      stone = stone.to_s
      half = stone.length / 2
      tick(stone[0..half-1].to_i, times - 1) + tick(stone[half..-1].to_i, times - 1)
    else
      tick(stone * 2024, times - 1)
    end
  #end
end

sum = stones.map do |stone|
  tick(stone, 75)
end.sum
puts sum
