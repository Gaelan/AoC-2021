inp = `pbpaste`
lines = inp.split("\n").map(&:to_i)

puts "p1"
p lines.zip(lines.drop(1)).filter { |x, y| x && y && y > x }.count

puts "p2"
windows = lines.zip(lines.drop(1), lines.drop(2)).find_all { |_, _, z| z }.map { |x, y, z| x + y + z }
p windows
p windows.zip(windows.drop(1)).filter { |x, y| x && y && y > x }.count
