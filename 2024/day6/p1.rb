#!/usr/bin/env ruby
require "set"

def seen_places
  @seen_places ||= []
end

@grid = []
@guard_pos = nil
ARGF.each_line do |row, i|
  @grid << row.chomp.scan(/./)
  if row =~ /[\^<>v]/
    @guard_pos = [row.index(/[\^<>v]/), @grid.length - 1]
    seen_places << @guard_pos.dup
  end
end

def guard
  @grid[@guard_pos[1]][@guard_pos[0]]
end

def step
  old_pos = @guard_pos.dup
  puts "(#{@guard_pos[0]}, #{@guard_pos[1]}) => #{guard}"
  case guard
  when '^'
    @guard_pos[1] -= 1
  when '>'
    @guard_pos[0] += 1
  when 'v'
    @guard_pos[1] += 1
  when '<'
    @guard_pos[0] -= 1
  else
    puts @grid[@guard_pos[1]].join("").inspect
    raise @grid.dig(*@guard_pos).inspect
  end
  if @guard_pos[0] < 0 || @guard_pos[0] >= @grid[0].length || @guard_pos[1] < 0 || @guard_pos[1] >= @grid.length
    puts "DONE"
    puts @guard_pos.inspect
    return false
  end
  if guard == "#"
    puts "blocked"
    @guard_pos = old_pos
    @grid[@guard_pos[1]][@guard_pos[0]] = turn_right
    return step
  else
    puts "moving -> "
    @grid[@guard_pos[1]][@guard_pos[0]] = @grid[old_pos[1]][old_pos[0]]
    @grid[old_pos[1]][old_pos[0]] = "."
    seen_places << @guard_pos.dup
    return true
  end
end

def turn_right
  case guard
  when "^"
    ">"
  when ">"
    "v"
  when "v"
    "<"
  when "<"
    "^"
  end
end

loop do
  break unless step
end
puts seen_places.to_a.uniq.inspect
puts seen_places.uniq.length
