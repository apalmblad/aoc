#!/usr/bin/env ruby

def map
  @map ||= ARGF.each_line.to_a.map(&:strip)
end

def height
  @map.length
end

def width
  @map.first.length
end

def results
  @results ||= begin
    height.times.map do |y|
      [-2] * width
    end
  end
end

def nest_results
  @nest_results ||= begin
    height.times.map do |y|
      ["."] * width
    end
  end
end

def adjacent(x, y)
  char = @map[y][x]
  return [] if char == "."
  return [[x,y-1], [x,y+1]] if char == "|"
  return [[x-1,y], [x+1, y]] if char == "-"
  return [[x,y-1], [x+1, y]] if char == "L"
  return [[x,y-1], [x-1, y]] if char == "J"
  return [[x,y+1], [x-1, y]] if char == "7"
  return [[x,y+1], [x+1, y]] if char == "F"
  if char == "S"
    start_adjacent = []
    start_adjacent << [x, y - 1] if %w(| F 7).include?(pos(x, y - 1))
    start_adjacent << [x - 1, y] if %w(- L F).include?(pos(x-1, y))
    start_adjacent << [x + 1, y] if %w(- J 7).include?(pos(x+1, y))
    start_adjacent << [x, y + 1] if %w(| J L).include?(pos(x, y + 1))
    return start_adjacent
  end
  raise "Unknown char: #{char}"
end

def steps(x, y)
  return results[y][x] if results[y][x] != -2

  char = @map[y][x]
  if char == "S"
    results[y][x] = 0
  end
  if char == "."
    results[y][x] = -1
  end
  adjacent(x, y).map do |adj_x, adj_y|
    adj_result = steps(adj_x, adj_y)
    next if adj_result == -1
    results[y][x] = adj_result + 1
    break
  end
  results[y][x]
end

def pos(x, y)
  map[y][x]
end

def set_result(x, y, result)
  results[y][x] = result
end

depth = 0
start = map.join("").index("S")
to_check = [[start % width, start / width]]
loop do
  next_depth = []
  to_check.each do |x, y|
    next if 0 > y || 0 > x
    next if height <= y || width <= x
    if pos(x, y) != "." && results[y][x] == -2
      set_result(x, y, depth)
      next_depth += adjacent(x, y)
    end
  end
  to_check = next_depth
  break if next_depth.empty?
  depth += 1
end
results.each do |row|
  puts row.join(" ")
end

def surrounded?(x, y)
  return false if x == 0 || y == 0 || x == width - 1 || y == height - 1
  return false if 0.upto(x-1).to_a.all? { |i| results[y][i] == -2 }
  return false if (width - x - 1).times.to_a.all? { |i| results[y][x + 1 + i] == -2 }
  return false if 0.upto(y-1).to_a.all? { |i| results[i][x] == -2 }
  return false if (height - y - 1).times.to_a.all? { |i| puts i; puts height; puts results[i+y].inspect; results[i+1+y][x] == -2 }
  left = results[y][0..x].each_with_index.map do |result, x1|
    if result != -2 && pos(x1, y) != "-"
      pos(x1, y)
    else
      nil
    end
  end.compact
  return false unless left.length % 2 == 1
  right = results[y][(x+1)..width].each_with_index.map do |result, x1|
    if result != -2 && pos(x+1+x1, y) != "-"
      pos(x1, y)
    else
      nil
    end
  end.compact
  return false unless right.length % 2 == 1
  below = (0..(y-1)).map { |y1| results[y1][x] }.each_with_index.map do |result, y1|
    if result != -2 && pos(x, y1) != "|"
      pos(x, y1)
    else
      nil
    end
  end.compact
  return false unless below.length % 2 == 1
  above = (height-y-1).times.map { |y1| results[y+1+y1][x] }.each_with_index.map do |result, y1|
    if result != -2 && pos(x, y+1+y1) != "|"
      pos(x, y+1+y1)
    else
      nil
    end
  end.compact
  return false unless above.length % 2 == 1
  return true
end

total = 0
results.each do |row|
  total = [*row, total].max
end

enclosed = 0
in_loop = false
results.each_with_index do |row, y|
  row.each_with_index do |col, x|
    if col != -2 && ["J", "|", "L"].include?(pos(x, y))
      in_loop = !in_loop
    elsif col == -2 && in_loop
      nest_results[y][x] = "I"
      enclosed += 1
    end
  end
end
nest_results.each do |row|
  puts row.join
end
puts
puts enclosed
