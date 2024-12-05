#!/usr/bin/env ruby
sum = 0
cards = {}
cards_to_handle = []
ARGF.each_line do |line|
  card, numbers = line.strip.split(":", 2)
  _, number = card.split(" ", 2)
  cards[number.to_i] = numbers.split("|", 2).map { |x| x.split(" ").map(&:to_i) }
  cards_to_handle << { number: number.to_i, winners: cards[number.to_i].first, present: cards[number.to_i].last }
end

cards_seen = []
card_no = 0
while card_no < cards_to_handle.length
  puts card_no
  card = cards_to_handle[card_no]
  puts (card[:winners] & card[:present]).inspect
  (card[:winners] & card[:present]).length.times do |i|
    added_card_number = card[:number] + i + 1
    cards_to_handle << { number: added_card_number, winners: cards[added_card_number].first, present: cards[added_card_number].last }
  end
  card_no += 1
end

puts cards_to_handle.length
