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

def get_endings(point)
  return [point] if value_at(*point) == 9
  @endings ||= {}
  @endings[point[X]] ||= {}
  @endings[point[X]][point[Y]] ||= begin
    puts "Next options for #{point.inspect} are #{next_options(point).inspect}"
    endings = []
    next_options(point).each do |option|
      endings += get_endings(option)
    end
    endings.uniq
  end
end

puts "There are #{trail_heads.length} trailheads"
puts trail_heads.inspect
x = trail_heads.sum do |trail_head|
  #puts "#{trail_head.inspect} has #{num_trails(trail_head)} trails"
  get_endings(trail_head).length
end
puts x
