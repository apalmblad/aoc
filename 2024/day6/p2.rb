#!/usr/bin/env ruby --jit
require "set"

def seen_places
  @seen_places ||= []
end
class Loop < StandardError
end

@grid = []
@guard_pos = nil
start_pos = nil
guard_start = nil
ARGF.each_line do |row, i|
  @grid << row.chomp.scan(/./)
  if row =~ /[\^<>v]/
    @guard_pos = [row.index(/[\^<>v]/), @grid.length - 1]
    start_pos = @guard_pos.dup
    seen_places << @guard_pos.dup
    guard_start = row[@guard_pos[0]]
  end
end

def guard
  @grid[@guard_pos[1]][@guard_pos[0]]
end

def step
  old_pos = @guard_pos.dup
  #puts "(#{@guard_pos[0]}, #{@guard_pos[1]}) => #{guard}"
  @loop_guard ||= {}
  if @loop_guard[guard]&.include?(@guard_pos)
    raise Loop
  else
    @loop_guard[guard] ||= []
    @loop_guard[guard] << @guard_pos.dup
  end

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
    raise guard
  end
  if @guard_pos[0] < 0 || @guard_pos[0] >= @grid[0].length || @guard_pos[1] < 0 || @guard_pos[1] >= @grid.length
    return false
  end
  if guard == "#"
    @guard_pos = old_pos
    @grid[@guard_pos[1]][@guard_pos[0]] = turn_right
    return step
  else
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
options = seen_places[1..].uniq
option_count = 0
options.each_with_index do |option, i|
  puts option.inspect + i.fdiv(options.length).to_s + " " + option_count.to_s
  next if option == start_pos
  @loop_guard = nil
  @guard_pos = start_pos.dup
  @grid[@guard_pos[1]][@guard_pos[0]] = guard_start
  @grid[option[1]][option[0]] = "#"
  loop do
    break unless step
  end
rescue Loop
  @grid[@guard_pos[1]][@guard_pos[0]] = "."
  option_count += 1
ensure
  @grid[option[1]][option[0]] = "."
end
puts option_count
