#!/usr/bin/env ruby
require 'forwardable'

class Page
  extend Forwardable
  attr_reader :num
  def initialize(num)
    @num = num
  end
  def greater_than(...)
    self.class.greater_than(...)
  end

  def less_than(...)
    self.class.less_than(...)
  end

  def <=>(b)
    if greater_than[num].include?(b.num)
      1
    elsif less_than[num].include?(b.num)
      -1
    else
      0
    end
  end

  def self.greater_than
    @greater_than ||= Hash.new { |h, k| h[k] = [] }
  end

  def self.less_than
    @less_than ||= Hash.new { |h, k| h[k] = [] }
  end
end
sections = []
in_sections = false
ARGF.each_line do |line|
  line.chomp!
  if line == ""
    in_sections = true
  elsif in_sections
    puts line
    sections << line.split(",").map(&:to_i).map { |x| Page.new(x) }
  else
    puts line
    smaller, bigger = line.split("|").map(&:to_i)
    Page.greater_than[smaller] << bigger
    Page.less_than[bigger] << smaller
  end
end
sum = 0
sections.each do |section|
  is_valid = true
  section.length.times do |start_pos|
    first, *rest = section[start_pos..]
    unless rest.all? { |x| (first <=> x) >= 0 }
      is_valid = false
      sum += section.sort[section.length / 2].num
      break
    end
  end
end
puts sum
