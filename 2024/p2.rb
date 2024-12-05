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

def surrounding_chars(x, y)
  down_right = grid[y-1][x-1] + grid[y][x] + grid[y+1][x+1]
  down_left = grid[y+1][x-1] + grid[y][x] + grid[y-1][x+1]
  [down_right, down_left]
end

def each_line
  1.upto(num_columns - 2) do |x|
    1.upto(num_rows - 2) do |y|
      yield surrounding_chars(x, y)
    end
  end
end

result = 0
each_line do |d1, d2|
  if (d1 == "SAM" || d1 == "MAS") && (d2 == "SAM" || d2 == "MAS")
    result += 1
  end
end
puts result
