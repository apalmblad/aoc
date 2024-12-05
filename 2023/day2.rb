#!/usr/bin/env ruby

games = {}
ARGF.each_line do |line|
  game, info = line.strip.split(": ", 2)
  colors = { "red" => 0, "green" => 0, "blue" => 0 }
  info.split("; ").each do |set|
    set.split(", ").each do |cube_set|
      count, color = cube_set.split(" ", 2)
      colors[color] = [colors[color], count.to_i].max
    end
  end
  games[game.split(" ").last.to_i] = colors
end
sum = 0
games.each_pair do |game_id, colors|
  if colors["red"] <= 12 && colors["green"] <= 13 && colors["blue"] <= 14
    sum += game_id
  end
end
puts "done"
puts sum
puts "done"

puts "p2"
puts games.values.map { |x| x["red"] * x["blue"] * x["green"] }.sum
