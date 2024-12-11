#!/usr/bin/env ruby
files = []
spaces = []
ARGF.each_line do |line|
  layout = line.chomp!.chars.map(&:to_i)
  layout.each_with_index do |num, i|
    if i % 2 == 0
      files << { id: i / 2, value: num }
    else
      spaces << num
    end
  end
end

disk = []
files.each_with_index do |file, i|
  disk += file[:value].times.map { file[:id] }
  puts "#{file[:id]} #{file[:value]}"
  empty_space = spaces[i] 
  while empty_space > 0 && files.last != file
    if empty_space >= files.last[:value]
      last_file = files.pop
      last_file[:value].times { disk << last_file[:id] }
      empty_space -= last_file[:value]
    else
      break if files.last.nil?
      puts files.last.inspect
      empty_space.times { disk << files.last[:id] }
      files.last[:value] -= empty_space
      empty_space = 0
    end
  end
end
puts disk.map(&:to_s).join("")
puts "result"
puts disk.each_with_index.sum { |id, pos| id * pos }
