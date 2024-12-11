#!/usr/bin/env ruby
X = 0
Y = 1
trail_heads = []
@grid = []
ARGF.each_line.each_with_index do |line, y|
  points = line.chomp.chars.map(&:to_i)
  @grid << points
  trail_heads += points.each_with_index.find_all { |x, y| x == 0 }.map{ |_val, pos| [pos, y] }
end

def width
  @grid.first.length
end

def height
  @grid.length
end

def value_at(*point)
  @grid[point[Y]][point[X]]
end

def next_options(point)
  cur_val = value_at(*point)
  return [] if cur_val == 9
  @options ||= {}
  @options[point[X]] ||= {}
  @options[point[X]][point[Y]] ||= begin
    options = []
    if point[X] > 0 && value_at(point[X] - 1, point[Y]) == cur_val + 1
      options << [point[X] - 1, point[Y]]
    end
    if point[X] < width - 1 && value_at(point[X] + 1, point[Y]) == cur_val + 1
      options << [point[X] + 1, point[Y]]
    end
    if point[Y] > 0 && value_at(point[X], point[Y] - 1) == cur_val + 1
      options << [point[X], point[Y] - 1]
    end
    if point[Y] < (height - 1) && value_at(point[X], point[Y] + 1) == (cur_val + 1)
      options << [point[X], point[Y] + 1]
    end
    options
  end
end

def num_trails(point)
  return 1 if value_at(*point) == 9
  @endings ||= {}
  @endings[point[X]] ||= {}
  @endings[point[X]][point[Y]] ||= begin
    puts "Next options for #{point.inspect} are #{next_options(point).inspect}"
    trails = 0
    next_options(point).sum do |option|
      num_trails(option)
    end
  end
end

puts "There are #{trail_heads.length} trailheads"
puts trail_heads.inspect
x = trail_heads.sum do |trail_head|
  #puts "#{trail_head.inspect} has #{num_trails(trail_head)} trails"
  num_trails(trail_head)
end
puts x
