#!/usr/bin/env ruby
time, distance, _ = ARGF.each.to_a.map(&:strip)
#times = time.split(/:\s+/, 2).last.split(/\s+/).map(&:to_i)
#distances = distance.split(/:\s+/, 2).last.split(/\s+/).map(&:to_i)
distances = [distance.split(/:\s+/, 2).last.gsub(/[^\d]/, "").to_i]
times = [time.split(/:\s+/, 2).last.gsub(/[^\d]/, "").to_i]

def calculate_distance(time_held, time_allowed)
  (time_allowed - time_held) * time_held
end
race_wins = []
times.length.times do |i|
  ways_to_win = 0
  0.upto(times[i]) do |time_holding|
    if calculate_distance(time_holding, times[i]) > distances[i]
      ways_to_win += 1
    elsif ways_to_win > 0
      break
    end
  end
  race_wins << ways_to_win
end

product = 1
race_wins.each do |item|
  product *= item
end
puts product

