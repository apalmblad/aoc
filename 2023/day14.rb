#!/usr/bin/env ruby

rows = ARGF.each_line.to_a.map(&:strip)
columns = rows.first.length.times.map do |c|
  rows.map { |x| x[c] }.join
end

rotated_columns = columns.map do |column|
  top = 0
  new_column = column.dup
  while pos = new_column.index(/[O#]/, top)
    if new_column[pos] == "O"
      old = new_column[top]
      new_column[top] = new_column[pos]
      new_column[pos] = old
      top += 1
    elsif new_column[pos] == "#"
      top = pos + 1
    else
      raise 'bad char'
    end
  end
  new_column
end

load = 0
rotated_columns.each do |col|
  start = 0
  puts
  puts
  puts col
  while pos = col.index("O", start)
    puts col[pos..-1].gsub(/#/, "")
    load += col[pos..-1].length # gsub(/#/, "").length
    start = pos + 1
  end
end
puts
puts load

# puts rotated_columns.inspect
#
# adjusted_rows = rows.length.times.map do |row_index|
#   rotated_columns.map { |x| x[row_index] }.join("")
# end
# puts
# puts
# adjusted_rows.each { |x| puts x }
