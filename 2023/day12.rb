#!/usr/bin/env ruby


def ranges_match_line(ranges, line)
  regex = "^\\.*" + ranges.map{ |x| "#\{#{x}}" }.join("\\.+") + "\\.*$"
#  puts "#{line} => #{regex} => #{Regexp.new(regex).match?(line)}"
  Regexp.new(regex).match?(line)
end

def generate_lines(line, ranges, needs_break: false)
  pos = line.index("?")
  line.scan(/#+/).first
  if pos
    memo = []
    first = line[0...pos] + "#"
    hash_ranges = if needs_break
                    first.scan(/\.+(#+)/).map(&:first)
                  else
                    first.scan(/#+/)
                  end

    hash_good = hash_ranges.each_with_index.all? do |hash_section, i|
      hash_section.length == ranges[i]
    end
    if hash_good
      generate_lines(line[pos+1..-1], ranges[hash_ranges.length .. -1], needs_break: true).each_with_object(memo) do |rh_line, memo|
        memo << first + "#" + rh_line
      end
    end

    last = line[0...pos] + "."
    hash_ranges = last.scan(/#+/)
    hash_good = hash_ranges.each_with_index.all? do |hash_section, i|
      hash_section.length == ranges[i]
    end
    if hash_good
      generate_lines(line[pos+1..-1], ranges[hash_ranges.length .. -1]).each_with_object(memo) do |rh_line, memo|
        memo << first + "." + rh_line
      end
    end
    puts memo.inspect
    memo
  else
    [line]
  end
end

sum = 0
ARGF.each_line do |line|
  break if line.strip == ""
  data, ranges = line.strip.split(" ")
  data = ([data] * 5).join("?")
  ranges = ranges.split(",").map(&:to_i) * 5
  generate_lines(data, ranges).each do |possible_line|
    sum += 1 if ranges_match_line(ranges, possible_line)
  end
end

puts
puts sum
