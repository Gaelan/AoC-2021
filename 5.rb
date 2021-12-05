input = `pbpaste`

Point = Struct.new(:x, :y)

class Line < Struct.new(:a, :b)
  def straight?
    a.x == b.x || a.y == b.y
  end

  def points
    if straight?
      if a.x == b.x
        y_range = ([a.y, b.y].min .. [a.y, b.y].max)
        y_range.map { |y| Point.new(a.x, y) }
      else
        x_range = ([a.x, b.x].min .. [a.x, b.x].max)
        x_range.map { |x| Point.new(x, a.y) }
      end
    else
      # must be diagonal
      ret = []
      p = self.a.dup
      loop do
        ret << p
        break if p == b
        p = p.dup
        if b.x > a.x
          p.x += 1
        else
          p.x -= 1
        end
        if b.y > a.y
          p.y += 1
        else
          p.y -= 1
        end
      end
      ret
    end
  end
end

lines = input.split("\n").map do |l|
  a, _, b = l.split(" ")
  a = Point.new(*a.split(",").map(&:to_i))
  b = Point.new(*b.split(",").map(&:to_i))
  Line.new(a, b)
end

points = lines.map(&:points).flatten
p points.count

counts = Hash.new 0

points.each do |point|
  counts[point] += 1
end

p counts.count { |k, v| v > 1 }
