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
end

class Map < Struct.new(:heights)
  def points
    heights.each_with_index.map do |row, y|
      row.each_with_index.map { |_, x| Point.new(x, y) }
    end.flatten
  end
  def height_at(point)
    return nil unless has_point?(point)
    heights[point.y][point.x]
  end
  def has_point?(point)
    point.x >= 0 && point.y >= 0 &&
      point.y < heights.length &&
      point.x < heights[0].length
  end
  def low_point?(point)
    area = [point.up, point.down, point.left, point.right]
      .filter { |point| has_point?(point) }
      .map { |point| height_at(point) }
    height_at(point) < area.min
  end
  def basin_size(point)
    throw "not low point" unless low_point?(point)
    considered = Set.new()
    _basin_size(considered, point)
  end
  def _basin_size(considered, point)
    return 0 unless has_point?(point)
    return 0 if considered.include? point
    return 0 if height_at(point) == 9
    considered.add(point)
    [point.up, point.down, point.left, point.right].map do |pt|
      _basin_size(considered, pt)
    end.sum + 1
  end
end

map = Map.new(input.split("\n").map { |row| row.chars.map(&:to_i) })

low_points = map.points.filter { |point| map.low_point?(point) }

puts "part 1"
p low_points.map { |point| map.height_at(point) + 1 }.sum

puts "part 2"
p low_points.map { |point| map.basin_size(point) }.sort.reverse[0..2].inject(:*)
