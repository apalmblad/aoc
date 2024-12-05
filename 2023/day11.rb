#!/usr/bin/env ruby

def lines
  @lines ||= ARGF.each_line.map(&:strip)
end

def columns
  @columns ||= begin
    lines.first.length.times.map do |col|
      @lines.map { |x| x[col] }.join("")
    end
  end
end

def rows
  lines
end

def empty_columns(s1, s2)
end

def expand_universe
  empty_rows = []
  empty_cols = []
  rows.each_with_index do |row, i|
    empty_rows << i if row =~ /^\.+$/
  end
  columns.each_with_index do |col, i|
    empty_cols << i if col =~ /^\.+$/
  end
  empty_rows.each_with_index do |row, i|
    lines.insert(row + (i * 1_000_000), lines[row+i].dup)
  end
  empty_cols.each_with_index do |row, i|
    lines.each do |line|
      line.insert(row + i , ".")
    end
  end
end

def galaxies
  r_val = []
  lines.each_with_index do |line, y|
    x = -1
    while x = line.index("#", x + 1)
      r_val << [x,y]
    end
  end
  r_val
end

def col_empty?(col)
  @col_empty ||= {}
  if @col_empty.key?(col)
    @col_empty[col]
  else
    @col_empty[col] ||= columns[col] =~ /^\.+$/
  end
end

def row_empty?(row)
  @row_empty ||= {}
  if @row_empty.key?(row)
    @row_empty[row]
  else
    @row_empty[row] ||= lines[row] =~ /^\.+$/
  end
end

def dump
  lines.each { |x| puts x }
end

# expand_universe

dump
points = galaxies
sum = 0
puts points.combination(2).to_a.inspect
puts points.combination(2).to_a.length.inspect
points.combination(2).each do |(x1, y1), (x2, y2)|
  (x1 > x2 ? x2.upto(x1 - 1) : x1.upto(x2 - 1)).each do |col|
    sum += col_empty?(col) ? 1_000_000 : 1
  end
  (y1 > y2 ? y2.upto(y1 - 1) : y1.upto(y2 - 1)).each do |row|
    sum += row_empty?(row) ? 1_000_000 : 1
  end
end
puts
puts sum
