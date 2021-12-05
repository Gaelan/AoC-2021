input = `pbpaste`
moves = input.split("\n").map { |x| dir, dist = x.split(" "); [dir.to_sym, dist.to_i] }
p moves

pos = 0
depth = 0
aim = 0

moves.each do |dir, dist|
  aim += dist if dir == :down
  aim -= dist if dir == :up
  if dir == :forward
    pos += dist
    depth += dist * aim
  end
end

p pos
p depth
p pos * depth
