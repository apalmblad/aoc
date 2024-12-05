#!/usr/bin/env ruby
safe = 0
ARGF.each_line do |line|
  last_num = nil
  is_safe = true
  dir = nil
  line.scan(/\d+/).each do |num|
    num = num.to_i
    if last_num
      diff = (last_num - num).abs
      if diff > 3 || diff == 0
        is_safe = false
        break
      end
      if dir 
        if (last_num - num) > 0 != dir > 0
          is_safe = false
          break
        end
      end
      dir = last_num - num
    end
    last_num = num
  end
  if is_safe
    puts line.strip + (is_safe ? " safe" : " not safe")
  end
  safe += 1 if is_safe
end
puts safe
