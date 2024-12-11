#!/usr/bin/env ruby
X = 0
Y = 1
@width = nil
@height = nil
def width
  @width
end
def height
  @height
end

antennas = Hash.new { |h, k| h[k] = [] }
ARGF.each_line.each_with_index do |line, i|
  line.chomp!
  @width ||= line.chars.length
  @height = i + 1
  line.scan(/[a-zA-Z0-9]/) do |match|
    puts "#{match} at (#{Regexp.last_match.begin(0)}, #{i})"
    antennas[match] << [Regexp.last_match.begin(0), i]
  end
end

def valid_point?(point)
  point[X] >= 0 && point[X] < width && point[Y] >= 0 && point[Y] < height
  #point[X] >= 0 && point[Y] >= 0
end

def antinode(p1, p2)
  x_distance = (p1[X] - p2[X]).abs
  y_distance = (p1[Y] - p2[Y]).abs
  an1 = []
  an2 = []
  if p1[X] < p2[X]
    an1[X] = p1[X] - x_distance
    an2[X] = p2[X] + x_distance
  else
    an1[X] = p1[X] + x_distance
    an2[X] = p2[X] - x_distance
  end
  if p1[Y] < p2[Y]
    an1[Y] = p1[Y] - y_distance
    an2[Y] = p2[Y] + y_distance
  else
    an1[Y] = p1[Y] + y_distance
    an2[Y] = p2[Y] - y_distance
  end
  [an1, an2].find_all { valid_point?(_1) }
end

locations = []
antennas.each do |antenna, points|
  points.combination(2) do |p1, p2|
    locations += antinode(p1, p2)
  end
end
puts 'testing'
puts antinode([6,5], [9, 9]).inspect
locations.uniq.tap do |x|
  puts x.sort_by { |x| x.last }.inspect
  puts x.length
end

