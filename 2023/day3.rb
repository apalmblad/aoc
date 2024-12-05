#!/usr/bin/env ruby

@rows = ARGF.each_line.to_a.map(&:strip)
def part1
  numbers = []
  @rows.each_with_index do |row, y|
    start = 0
    loop do
      number_start = row.index(/\d+/, start)

      if number_start
        number_end = row.index(/[^0-9]/, number_start) || row.length
        numbers << [number_start, y, row[number_start...number_end]]
        puts number_end
        start = number_end
      else
        break
      end
    end
  end
end

def width
  @rows.first.length
end

def height
  @rows.length
end

def part2
  numbers = []
  @rows.each_with_index do |row, y|
    number_start = -1
    loop do
      number_start = row.index("*", number_start + 1)

      if number_start
        number_end = row.index(/[^0-9]/, number_start) || row.length
        numbers << [number_start, y]
      else
        break
      end
    end
  end
  numbers
end

def number_at(x, y)
  return nil if x < 0 || y < 0
  return nil if x >= width || y >= height
  return nil unless @rows[y][x] =~ /\d/
  puts @rows[y][x]
  start = x
  while start >= 0
    break unless @rows[y][start] =~ /\d/
    start -= 1
  end
  num_end = x
  while num_end < width
    break unless @rows[y][num_end] =~ /\d/
    num_end += 1
  end
  [start, num_end, @rows[y][(start+1) .. (num_end-1)].to_i]
end

gears = part2
puts gears.inspect
sum = 0
gears.each do |x, y|
  numbers = []
  # sides
  numbers << number_at(x-1, y)
  numbers << number_at(x+1, y)

  numbers << number_at(x-1, y-1)
  numbers << number_at(x, y-1)
  numbers << number_at(x+1, y-1)

  numbers << number_at(x+1, y+1)
  numbers << number_at(x, y+1)
  numbers << number_at(x-1, y+1)
  numbers.compact!.uniq!
  if numbers.length == 2
    sum += numbers.first.last * numbers.last.last
  end
end
puts sum

exit




def adjacent_values(x, y)
  value = []
  value << @rows[y][x-1] if x > 0 # left
  value << @rows[y-1][x-1] if x > 0 && y > 0 # tl
  value << @rows[y-1][x] if y > 0 # t
  value << @rows[y-1][x+1] if y > 0 && x < width - 1# tr
  value << @rows[y][x+1] if x < width - 1# r
  value << @rows[y+1][x+1] if x < width - 1 && y < height - 1# br
  value << @rows[y+1][x] if y < height - 1# b
  value << @rows[y+1][x-1] if x > 0 && y < height - 1# bl
  value
end

def adjacent(x, y, number)
  number.length.times do |i|
    return true if adjacent_values(x + i, y).join("") =~ /[^0-9.]/
  end
  false
end

sum = 0
numbers.each do |x, y, number|
  if adjacent(x, y, number)
    sum += number.to_i
  else
    puts number
  end
end
puts sum

  
