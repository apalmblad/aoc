#!/usr/bin/env ruby
lines = ARGF.each_line.to_a
directions = lines.shift.strip
lines.shift
nodes = {}
lines.each do |line|
  node, options =line.strip.split(" = ")
  nodes[node] = { dirs: options[1..-2].split(", ", 2), name: node }
end
puts nodes.inspect

steps = 0
current_nodes = nodes.values_at(*nodes.keys.find_all { |x| x =~ /A$/ })

current_nodes.each do |node|
  start = node
  potential_loop = []
  steps = 0
  loop do
    if steps % 100_000 == 0
      putc '.'
      $stdout.flush
    end
    step_to_take = directions.chars[steps % directions.length]
    if step_to_take =="R"
      node = nodes[node[:dirs].last]
    else
      node = nodes[node[:dirs].first]
    end
    steps += 1
    if node[:name] =~ /Z$/
      potential_loop << steps
      puts steps
      puts "#{steps} #{node[:name]} #{potential_loop.inspect} #{steps % directions.length}"
      if potential_loop.map { |x| x % directions.length }.include?(steps % directions.length)
        puts 'done'
        break
      end
    end
    if node[:name] == start[:name]
      puts node.inspect
      puts steps
      break
    end
  end
end
puts 'done loops'
exit

while !current_nodes.all? { |x| x[:name] =~ /Z$/ }
  if steps % 100_000 == 0
    putc '.'
    $stdout.flush
  end
  step_to_take = directions.chars[steps % directions.length]
  case step_to_take
  when "R"
    current_nodes.map! do |x|
      nodes[x[:dirs].last]
    end
  when "L"
    current_nodes.map! do |x|
      nodes[x[:dirs].first]
    end
  else
    raise step_to_take
  end
  steps += 1
end
puts steps

