#!/usr/bin/env ruby

hands = []
ARGF.each do |line|
  hand, bid = line.strip.split(" ", 2)
  hands << { hand: hand, bid: bid.to_i }
end

def type_of_hand(hand)
  sorted = hand.chars.sort
  # A8J5J
  return 0 if sorted[0] == sorted[-1]
  counts = sorted.inject({}) { |memo, x| memo[x] ||= 0; memo[x] += 1; memo }
  return 0 if counts.reject { |x, _| x == "J" }.values.max + counts.fetch("J", 0) == 5

  return 1 if counts.values.any? { |x| x == 4 }
  return 1 if counts.reject { |x, _| x == "J" }.values.max + counts.fetch("J", 0) == 4
  # full house
  return 2 if counts.keys.length == 2
  return 2 if counts["J"] && counts.keys.length == 3
  # three of a kind
  return 3 if counts.reject { |x, _| x == "J" }.values.max + counts.fetch("J", 0) == 3
  # 2 pair
  sorted_counts = counts.values.sort 
  # no wild card cause 3 of kind gets made
  return 4 if sorted_counts.length == 3 && sorted_counts[1] == 2 && sorted_counts[2] ==2

  return 5 if counts.values.any? { |x| x == 2 } || counts["J"]
  return 6
end
LOOKUP = {"A" => 0, "K" => 1, "Q" => 2, "J" => 13, "T" => 4, "9" => 5, "8" => 6, "7" => 7, "6" => 8, "5" => 9, "4" => 10, "3" => 11, "2" => 12 }

def card_compare(card1, card2)
  LOOKUP.fetch(card1) <=> LOOKUP.fetch(card2)
end

def compare_hand_cards(a, b)
  a.length.times do |i|
    result = card_compare(a[i], b[i])
    return result unless result == 0
  end
  return 0
end


hands.sort! do |a, b|
  cmp = type_of_hand(a[:hand]) <=> type_of_hand(b[:hand])
  cmp == 0 ? compare_hand_cards(a[:hand], b[:hand]) : cmp
end
sum = 0
hands.reverse.each_with_index do |hand, i|
  puts hand[:hand]
  sum += hand[:bid] * (i + 1)
end
puts sum
