#!/usr/bin/env ruby --jit

class Integer
  def combine(val)
    (self.to_s + val.to_s).to_i
  end
end

def operator_options(length)
  @combos ||= {} 
  @combos[length] ||= begin
    if length == 2
      [[:+], [:*], [:combine]]
    else
      result = []
      operator_options(length - 1).each do |option_set|
        [[:+], [:*], [:combine]].each do |op|
          result << [*option_set, *op]
        end
      end
      result
    end
  end
  @combos[length]
end

sum = 0
ARGF.each_line do |line|
  result, numbers = line.chomp.split(":", 2)
  result = result.to_i
  numbers = numbers.scan(/\d+/).map(&:to_i)
  puts numbers.inspect
  operator_options(numbers.length).each do |ops|
    potential_result = numbers[0]
    ops.each_with_index do |operator, i|
      potential_result = potential_result.send(operator, numbers[i + 1])
      break if potential_result > result
    end
    if potential_result == result
      sum += result
      break
    end
  end
end
puts sum
