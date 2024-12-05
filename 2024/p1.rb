#!/usr/bin/env ruby

def grid
  @grid ||= begin
    rows = []
    ARGF.each_line do |line|
      rows << line.chomp.scan(/./)
    end
    rows
  end
end

def num_columns
  grid.first.length
end

def num_rows
  grid.length
end

def each_line
  grid.each do |row|
    yield row
  end
  puts
  num_columns.times do |i|
    yield grid.map { |x| x[i] }
    yield down_right_diagonal(x, 0)
    yield down_left_diagonal(x, 0)
  end
  puts
  (num_rows - 1).times do |y|
    yield down_right_diagonal(0, y + 1)
    yield down_left_diagonal(num_columns - 1, y + 1)
  end
end

def down_right_diagonal(x,y)
  r_val = []
  while x < num_rows && y < num_columns
    r_val << grid[y][x]
    x += 1
    y += 1
  end
  r_val
end

def down_left_diagonal(x, y)
  r_val = []
  while x >= 0 && y < num_rows
    r_val << grid[y][x]
    x -= 1
    y += 1
  end
  r_val
end

word = "XMAS"
result = 0
each_line do |line|
  chars = line.join("")
  puts chars
  result += chars.scan(word).count + chars.scan(word.reverse).count
end
puts result
