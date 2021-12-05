input = `pbpaste`

Point = Struct.new(:x, :y)

class Line < Struct.new(:a, :b)
  def straight?
    a.x == b.x || a.y == b.y
  end

  def contains?(point)
    throw "not straight" if !straight?
    if a.x == b.x
      y_range = ([a.y, b.y].min .. [a.y, b.y].max)
      (point.x == a.x) && y_range.include?(point.y)
    else
      x_range = ([a.x, b.x].min .. [a.x, b.x].max)
      (point.y == a.y) && (x_range.include? point.x)
    end
  end

  def points
    throw "not straight" if !straight?
    if a.x == b.x
      y_range = ([a.y, b.y].min .. [a.y, b.y].max)
      y_range.map { |y| Point.new(a.x, y) }
    else
      x_range = ([a.x, b.x].min .. [a.x, b.x].max)
      x_range.map { |x| Point.new(x, a.y) }
    end
  end
end

lines = input.split("\n").map do |l|
  a, _, b = l.split(" ")
  a = Point.new(*a.split(",").map(&:to_i))
  b = Point.new(*b.split(",").map(&:to_i))
  Line.new(a, b)
end

straight_lines = lines.find_all(&:straight?)

points = straight_lines.map(&:points).flatten
p points.count

counts = Hash.new 0

points.each do |point|
  counts[point] += 1
end

p counts.count { |k, v| v > 1 }

exit

x_max = [
  lines.map { |l| l.a.x }.max,
  lines.map { |l| l.b.x }.max,
].max
y_max = [
  lines.map { |l| l.a.y }.max,
  lines.map { |l| l.b.y }.max,
].max

p x_max, y_max

points = (0..x_max).map { |x| (0..y_max).map { |y| Point.new(x, y) } }.flatten

p(points.count do |point|
  straight_lines.count { |line| line.contains? point } > 1
end)
