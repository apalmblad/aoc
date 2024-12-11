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
  if p2[Y] < p1[Y]
    p2, p1 = p1, p2
  end

  x_distance = (p1[X] - p2[X]).abs
  y_distance = (p1[Y] - p2[Y]).abs
  r_val = []
  i = 0
  loop do
    new_point = if p1[X] < p2[X]
      [p1[X] - (x_distance * i), p1[Y] - (y_distance * i)]
    else
      [p1[X] + (x_distance * i), p1[Y] - (y_distance * i)]
    end
    if valid_point?(new_point)
      r_val << new_point
    else
      break
    end
    i += 1
  end

  i = 0
  loop do
    new_point = if p1[X] < p2[X]
      [p1[X] + (x_distance * i), p1[Y] + (y_distance * i)]
    else
      [p1[X] - (x_distance * i), p1[Y] + (y_distance * i)]
    end
    if valid_point?(new_point)
      r_val << new_point
    else
      break
    end
    i+=1
  end
  r_val
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

