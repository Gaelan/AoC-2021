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
  def inspect
    "(#{x}, #{y})"
  end
end
class Fold < Struct.new(:axis, :line)
end

def dbg_points(points)
  x_max = points.map(&:x).max
  y_max = points.map(&:y).max
  (0..y_max).each do |y|
    (0..x_max).each do |x|
      if points.include? Point.new(x, y)
        print "#"
      else
        print "."
      end
    end
    print "\n"
  end
end

points, folds = input.split("\n\n")

points = points.split("\n").map do |point|
  x, y = point.split(",").map(&:to_i)
  Point.new(x, y)
end

folds = folds.split("\n").map do |fold|
  _, _, fold = fold.split(" ")
  axis, line = fold.split("=")
  Fold.new(axis.to_sym, line.to_i)
end

folds.each_with_index do |fold, idx|
  case fold.axis
  when :x
    points.each do |point|
      if point.x > fold.line
        point.x = fold.line - (point.x - fold.line)
      end
    end
  when :y
    points.each do |point|
      if point.y > fold.line
        point.y = fold.line - (point.y - fold.line)
      end
    end
  end
  points = points.uniq

  if idx == 0
    puts "== part 1 =="
    #dbg_points(points)
    p points.length
  end
end

dbg_points(points)
p points.count
