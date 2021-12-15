require 'set'

input = `pbpaste`

class Point < Struct.new(:x, :y)
  def up
    Point.new(x, y - 1)
  end
  def down
    Point.new(x, y + 1)
  end
  def left
    Point.new(x - 1, y)
  end
  def right
    Point.new(x + 1, y)
  end
  def neighbors
    [up, down, left, right, up.left, up.right, down.left, down.right]
  end
  def inspect
    "(#{x}, #{y})"
  end
end

levels = {}

input.split("\n").each_with_index do |line, y|
  line.chars.each_with_index do |level, x|
    levels[Point[x, y]] = level.to_i
  end
end

i = 1
loop do
  levels.keys.each { |pt| levels[pt] += 1 }
  flashed = Set.new
  loop do
    any_flashed = false
    levels.each do |point, level|
      if level > 9 && !(flashed.include? point)
        flashed.add point
        point.neighbors.each do |n|
          levels[n] += 1 if levels[n] != nil
        end
        any_flashed = true
      end
    end
    break unless any_flashed
  end
  puts "#{i}: #{flashed.length}"
  break if flashed.length == levels.length
  flashed.each { |point| levels[point] = 0 }
  i += 1
end
